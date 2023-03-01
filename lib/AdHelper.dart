import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3619557733262051/5373785997';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3619557733262051/9094922049';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
    //dummy
    //    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3619557733262051/6495295976';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3619557733262051/9143039412';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    return "ca-app-pub-3619557733262051~3022954821";
  }
}
