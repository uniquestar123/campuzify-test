import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInProvider {
  Future<LoginResult> facebookSignIn() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    return result;
  }
}
