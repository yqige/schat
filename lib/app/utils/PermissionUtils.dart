import 'package:flutter/widgets.dart';
import 'package:simple_permissions/simple_permissions.dart';
class PermissionUtils{

  static requestPermission(Permission permission) async {
    debugPrint('权限:${permission.index}');
    final res = await SimplePermissions.requestPermission(permission);
    debugPrint("permission request result is " + res.toString());
  }

  static checkPermission(Permission permission) async {
    bool res = await SimplePermissions.checkPermission(permission);
    print("permission is " + res.toString());
  }

  static getPermissionStatus(Permission permission) async {
    final res = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is " + res.toString());
  }

}
