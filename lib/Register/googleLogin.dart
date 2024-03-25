import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildTitle(),
          const BuildLogin(),
        ],
      ),
    );
  }
}

Widget _buildTitle() {
  return Container(
    padding: const EdgeInsets.all(8),
    alignment: Alignment.center,
    width: 150,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: FadeInUp(
        duration: const Duration(milliseconds: 1800),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child: Column(
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                  width: 300,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tong_logo_name.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          ),
        )),
  );
}

class BuildLogin extends StatefulWidget {
  const BuildLogin({super.key});

  @override
  State<BuildLogin> createState() => BuildLoginState();
}

class BuildLoginState extends State<BuildLogin> {
  void _signInWithGoogle() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      print("Logged in with Google: ${userCredential.user}");
      context.go('/homepage');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: const EdgeInsets.all(20),
            width: 450,
            child: SignInButton(
              Buttons.google,
              text: "Sign in with Google",
              onPressed: _signInWithGoogle,
            ),
          ),
        ),
      ],
    );
  }
}
