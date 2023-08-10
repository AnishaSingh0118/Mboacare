import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';
import 'login.dart';
import 'dashboard.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToHome() async {
      await Future.delayed(Duration(milliseconds: 3000), () {});
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => DashboardScreen(userName: 'Mboacare'),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });

    return Scaffold(
      backgroundColor:
          Colors.white, // Replace with your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCube(
              color: Colors.blue, // Replace with your desired spinner color
              size:
                  50.0, // Adjust the size of the spinner as per your requirements
            ),
            SizedBox(height: 16.0),
            Image.asset(
              'lib/assests/images/logo.png', // Replace with your own image path
              width: 130, // Adjust the width as per your requirements
              height: 130, // Adjust the height as per your requirements
            ),
            SizedBox(height: 16.0),
            Text(
              'Mboacare',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Health, Simplified!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
