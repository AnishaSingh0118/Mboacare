import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _registrationStatus = '';

  void _signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      // Registration successful
      setState(() {
        _registrationStatus = 'Registration successful';
      });
    } catch (e) {
      print(e.toString()); // Print the exact error message
      // Registration failed
      setState(() {
        _registrationStatus = 'Registration failed: ${e.toString()}';
      });
    }
  }

  Future<void> _signUpWithGoogle() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = finalResult.user;
      // Do something with the authenticated user
      print("Result $result");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assests/images/logo.png',
                  width: 125,
                ),
                SizedBox(height: 50),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: AppColors.email,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 10.0,
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: AppColors.primaryColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: AppColors.password,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: AppColors.primaryColor),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  width: 320,
                  child: ElevatedButton(
                    onPressed: _signUpWithEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _registrationStatus,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  width: 320,
                  child: ElevatedButton(
                    onPressed: _signUpWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.googleButtonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assests/images/google-icon.png',
                          height: 32,
                          width: 32,
                        ),
                        SizedBox(width: 8),
                        Text('Register with Google'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
