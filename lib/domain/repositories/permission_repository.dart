abstract class PermissionRepository {
  /// Requests microphone and location permissions.
  /// Returns `true` if both permissions are granted, `false` otherwise.
  Future<bool> requestPermissions();
}