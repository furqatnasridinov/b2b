
class PermissionUtils {
  /// Checks the current status of camera and microphone permissions.
  /// Returns `true` if both camera and microphone permissions are granted.
  /* Future<bool> getCameraAndMicrophonePermissionStatus() async {
    // Get the current status of camera and microphone permissions
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    // Check if both camera and microphone permissions are granted
    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      return true;
    }
    return false;
  }

  /// Requests camera and microphone permissions and returns `true` if granted.
  Future<bool> askForPermission() async {
    // Request camera and microphone permissions
    final status = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Check if both camera and microphone permissions are granted
    if (status[Permission.camera]!.isGranted &&
        status[Permission.microphone]!.isGranted) {
      return true;
    }
    return false;
  } */
}
