import 'package:permission_handler/permission_handler.dart';
import 'package:whobird_flutter/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  @override
  Future<bool> requestPermissions() async {
    // Request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.location,
    ].request();

    // Check if both permissions are granted.
    final bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;
    final bool locationGranted = statuses[Permission.location]?.isGranted ?? false;

    return micGranted && locationGranted;
  }
}