import 'package:permission_handler/permission_handler.dart';


class PermissionProvider {
  static Future<void> requestPermission(Permission permission) async {
    if (!await permission.isGranted) {
      await permission.request();
    } else if (await permission.isPermanentlyDenied ||
        await permission.isDenied) {
      openAppSettings();
    }
  }
}
