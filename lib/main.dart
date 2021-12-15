import 'package:flutter/material.dart';
import 'package:flutter_aws/auth_service.dart';
import 'package:flutter_aws/login_page.dart';
import 'package:flutter_aws/sign_up_page.dart';
import 'package:flutter_aws/verification_page.dart';

import 'camera_flow.dart';

void main() {
  runApp(MyApp());
}

// 1
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // 1
      home: StreamBuilder<AuthState>(
        // 2
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4
                  // Show Login Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                            didProvideCredentials: _authService.loginWithCredentials,
                            shouldShowSignUp: _authService.showSignUp)),
                  // 5
                  // Show Sign Up Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                            didProvideCredentials: _authService.signUpWithCredentials,
                            shouldShowLogin: _authService.showLogin)),
                  // Show Verification Code Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.verification)
                    MaterialPage(child: VerificationPage(
                        didProvideVerificationCode: _authService.verifyCode)),
                  // Show Camera Flow
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: CameraFlow(shouldLogOut: _authService.logOut)),
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}