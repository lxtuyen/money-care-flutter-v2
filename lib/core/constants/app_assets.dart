class AppAssets {
  AppAssets._();

  static const String _iconPrefix = 'assets/icons/';
  static const String _soundVoicePrefix = 'assets/sound/voice/';
  static const String _soundTonePrefix = 'assets/sound/tone/';
  static const String _imagePrefix = 'assets/images/';

  static const String _typePng = '.png';
  static const String _typeSvg = '.svg';
  static const String _typeWav = '.wav';

  static String iconSvgPath(String iconName) {
    return '$_iconPrefix$iconName$_typeSvg';
  }

  static String iconPngPath(String iconName) {
    return '$_iconPrefix$iconName$_typePng';
  }

  static String soundVoicePath(String soundName) {
    return '$_soundVoicePrefix$soundName$_typeWav';
  }

  static String soundTonePath(String soundName) {
    return '$_soundTonePrefix$soundName$_typeWav';
  }

  static String imagePngPath(String imageName) {
    return '$_imagePrefix$imageName$_typePng';
  }
}


