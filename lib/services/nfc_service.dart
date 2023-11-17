import 'package:flutter_pcsc_platform_interface/flutter_pcsc_platform_interface.dart';

class NFCService {
  static const List<int> getCardSerialNumberCommand = [
    0xFF,
    0xCA,
    0x00,
    0x00,
    0x00
  ];

  Future<String?> getCardSerialNumber() async {
    int ctx = await PcscPlatform.instance
        .establishContext(PcscConstants.CARD_SCOPE_USER);
    Map? card;
    String? cardSerialNumber;

    try {
      List<String> readers = await PcscPlatform.instance.listReaders(ctx);

      if (readers.isEmpty) {
        return null; // No card reader found
      }

      String reader = readers[0];
      card = await PcscPlatform.instance.cardConnect(ctx, reader,
          PcscConstants.SCARD_SHARE_SHARED, PcscConstants.SCARD_PROTOCOL_ANY);
      var response = await PcscPlatform.instance.transmit(card['h_card'],
          card['active_protocol'], getCardSerialNumberCommand);
      var sw = response.sublist(response.length - 2);
      var sn = response.sublist(0, response.length - 2);

      if (sw[0] == 0x90 && sw[1] == 0x00) {
        // Card returned success
        cardSerialNumber = hexDump(sn);
      }
    } finally {
      if (card != null) {
        try {
          await PcscPlatform.instance.cardDisconnect(
              card['h_card'], PcscConstants.SCARD_RESET_CARD);
        } catch (e) {
          // Handle disconnect error
        }
      }
      try {
        await PcscPlatform.instance.releaseContext(ctx);
      } catch (e) {
        // Handle release context error
      }
    }

    return cardSerialNumber;
  }

  static String hexDump(List<int> csn) {
    return csn
        .map((i) => i.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join('');
  }
}
