import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUpPage.dart';
import 'register.dart';
import 'dashboard.dart';
import 'colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required String title}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _checkUserLoggedIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      if (email.isEmpty || password.isEmpty) {
        _showMessage("Please enter email and password.");
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          _showMessage(
              "A verification email has been sent to your email address. Please verify your email.");
        } else {
          _saveUserEmail(user.email!);
          _showMessage("Sign in successful: ${user.email}");
// Navigate to register.dart
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage("User account not found. Please sign in with Google.");
      } else {
        _showMessage("Sign in failed: ${e.toString()}");
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser != null) {
        _navigatetoHospitalRegistrationForm();
      }
    } catch (e) {
      _showMessage("Google sign-in failed: ${e.toString()}");
    }
  }

  Future<void> _sendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
      _showMessage(
          "A verification email has been sent to your email address. Please verify your email.");
    } catch (e) {
      _showMessage("Email verification failed: ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigatetoHospitalRegistrationForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
  }

  _saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }

  Future<String?> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  _checkUserLoggedIn() async {
    String? userEmail = await _getUserEmail();
    if (userEmail != null && userEmail.isNotEmpty) {
      print(userEmail);
      // _navigateToRegisterPage();
    }
  }

  void _navigateToRegisterPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterPage(),
        ));
  }

  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage(
          "A password reset email has been sent to your email address. Please follow the instructions to reset your password.");
    } catch (e) {
      _showMessage("Password reset email failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              SizedBox(height: 40),
              // Email Box
              SizedBox(
                width: 350,
                height: 50,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password Box
              SizedBox(
                width: 350,
                height: 50,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 24),
              // Login with Email Button
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(340, 45),
                ),
                child: Text(
                  "Login with Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Login with Google Button
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(340, 45),
                ),
                icon: Image.asset(
                  'lib/assests/images/google-icon.png',
                  height: 32,
                  width: 32,
                ),
                label: Text(
                  "Login with Google",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignUpPage()));
                },
                child: Text("Don't have an account? Sign up"),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _sendPasswordResetEmail(_emailController.text.trim());
                  } else {
                    _showMessage(
                        "Please enter your email to reset the password.");
                  }
                },
                child: Text("Forgot password? Reset here."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
