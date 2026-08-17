/// Variable instances from assets directory
///
/// Defined asset's path with base prefix according to the
/// asset's type. DO NOT use literal string for asset's path
///
/// ```dart
/// Media.homeIcon;
/// Media.flutterLogo;
/// ```
class Media {
  const Media._();

  //base path of images
  static const _baseLogo = 'assets/logo';
  static const _baseImage = 'assets/images';
  static const _baseSvg = 'assets/svgs';
  static const _baseLottie = 'assets/lottie';

  //images
  
  // lottie


  // svgs


  // lottie
  static const rockLottie = '$_baseLottie/rock.tgs';
}
