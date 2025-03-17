import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class KeycloakService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final String clientId = 'flutter-app-csi408-mct'; // Your Client ID
  final String redirectUrl = 'http://10.220.6.32:8000/'; // Your Redirect URL
  final String issuer =
      'http://localhost:8080/realms/medication-compliance-tool'; // Your Keycloak realm URL

  Future<Map<String, dynamic>?> login() async {
    final AuthorizationTokenResponse result = await _appAuth
        .authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            clientId,
            redirectUrl,
            issuer: issuer,
            scopes: ['openid', 'profile', 'email'],
          ),
        );

    // Decode the token and return the user info
    return JwtDecoder.decode(result.idToken!);
  }
}
