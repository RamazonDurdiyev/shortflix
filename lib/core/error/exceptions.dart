class ServerUnknownException implements Exception {}

class CacheException implements Exception {}

class NetworkException {}

class AuthException implements Exception {
  final String message;
  AuthException([
    this.message =
        "Authentication failed: refresh token is missing, expired, or invalid",
  ]);

  @override
  String toString() => "AuthException: $message";
}
