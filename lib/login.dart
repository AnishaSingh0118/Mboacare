import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mboacare/colors.dart';
import 'package:mboacare/signUpPage.dart';
import 'package:mboacare/dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required String title}) : super(key: key);

  Future<void> googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }
      print("Result $result");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  Future<void> signInWithEmail(BuildContext context) async {
    try {
      // Perform user verification here
      // For example, you can use Firebase Authentication to verify the user's email and password

      // Simulating a successful verification
      bool isUserVerified = true;

      if (isUserVerified) {
        // Redirect to the main screen if the user is verified
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } catch (error) {
      // Handle any potential errors during user verification
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred during user verification: $error'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Login')),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 50.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assests/images/logo.png',
                width: 180,
              ),
              SizedBox(height: 12),
              Text(
                'Welcome to Mboacare',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Your Health, Simplified!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.signInButtonColor,
                ),
              ),
              SizedBox(height: 80),
              Container(
                width: 320,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => signInWithEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 320,
                height: 40,
                child: FloatingActionButton.extended(
                  onPressed: googleLogin,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.googleButtonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: Image.asset(
                    'lib/assests/images/google-icon.png',
                    height: 32,
                    width: 32,
                  ),
                  label: Text('Sign in with Google'),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
