import 'package:flutter_pcsc/flutter_pcsc.dart';

class NFCService {
  Stream<String>? _nfcEventStream;

  Stream<String> get onNFCEvent {
    _nfcEventStream ??= Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
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
    }).distinct();
    return _nfcEventStream!;
  }

  void disposeNFCListener() {
    _nfcEventStream?.drain();
    _nfcEventStream = null;
  }

  String hexDump(List<int> data) {
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }
}