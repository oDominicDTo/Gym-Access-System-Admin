import 'dart:async';
import 'package:flutter_pcsc/flutter_pcsc.dart';

class NFCService {
  StreamController<String>? _nfcEventController;
  Stream<String>? _nfcEventStream;
  StreamSubscription<String>? _nfcSubscription;

  Stream<String> get onNFCEvent {
    _nfcEventController ??= StreamController<String>.broadcast();
    _nfcEventStream ??= _nfcEventController!.stream;

    _nfcSubscription ??= startListening();

    return _nfcEventStream!;
  }

  StreamSubscription<String> startListening() {
    return Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
      try {
        int context = await Pcsc.establishContext(PcscSCope.user);
        List<String> readers = await Pcsc.listReaders(context);

        if (readers.isNotEmpty) {
          String reader = readers[0];
          CardStruct card = await Pcsc.cardConnect(
            context,
            reader,
            PcscShare.shared,
            PcscProtocol.any,
          );

          List<int> response = await Pcsc.transmit(
            card,
            [0xFF, 0xCA, 0x00, 0x00, 0x00],
          );

          var sw = response.sublist(response.length - 2);
          var sn = response.sublist(0, response.length - 2);

          await Pcsc.cardDisconnect(card.hCard, PcscDisposition.resetCard);
          await Pcsc.releaseContext(context);

          if (sw[0] == 0x90 && sw[1] == 0x00) {
            return hexDump(sn);
          }
        }
      } catch (e) {
        if (e.toString().contains('SCARD_W_REMOVED_CARD')) {
          return 'Error';
        }
      }
      return 'Error';
    }).distinct().listen((String tagId) {
      if (tagId != 'Error') {
        _nfcEventController!.add(tagId);
      }
    });
  }

  void disposeNFCListener() {
    _nfcEventController?.close();
    _nfcSubscription?.cancel();
    _nfcEventController = null;
    _nfcEventStream = null;
    _nfcSubscription = null;
  }
  void dispose() {
    disposeNFCListener();
    // Add any other resource cleanup needed for NFCService
  }
  String hexDump(List<int> data) {
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }
}
