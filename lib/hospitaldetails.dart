import 'package:flutter/material.dart';
import 'hospital.dart';

class HospitalDetailsPage extends StatelessWidget {
  final Hospital hospital;

  HospitalDetailsPage({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: AssetImage(hospital.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                hospital.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                hospital.specialty,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text('Specialties: ${hospital.keywords.join(", ")}'),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Add your logic here to show more details about the hospital
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coming soon!")),
                  );
                },
                child: Text("View More Details"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
