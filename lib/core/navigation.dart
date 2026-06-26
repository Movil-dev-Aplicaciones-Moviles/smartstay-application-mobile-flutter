part of '../main.dart';

void goToLogin(BuildContext context) {
  Session.user = null;
  Session.token = null;
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
}
