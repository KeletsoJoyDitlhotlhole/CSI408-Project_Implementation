import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
final _secureStorage = FlutterSecureStorage();

final String clientId = 'your-client-id';
final String redirectUri = 'com.yourapp:/oauth2redirect';
final String issuer =
    'https://lemur-6.cloud-iam.com/auth/realms/csi408-medication-compliance-tool';

Future<void> signIn() async {
  final AuthorizationTokenResponse result = await appAuth
      .authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          issuer: issuer,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

  // Store the tokens securely
  await _secureStorage.write(key: 'access_token', value: result.accessToken);
  await _secureStorage.write(key: 'refresh_token', value: result.refreshToken);
}
