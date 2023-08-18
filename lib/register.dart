import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'colors.dart';
import 'hospital_provider.dart';
import 'hospital_model.dart';
import 'package:http/http.dart' as http;
import 'hospitaldashboard.dart';
import 'dashboard.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _hospitalName;
  String? _hospitalAddress;
  String? _hospitalPhone;
  String? _hospitalEmail;
  String? _hospitalWebsite;
  String? _hospitalType;
  String? _hospitalSize;
  String? _hospitalOwnership;
  String? _hospitalSpecialities;
  String? _hospitalFacilities;
  String? _hospitalBedCapacity;
  String? _hospitalEmergencyServices;

  final String documentId =
      'aeac9fSTIeI6UD0OywSj'; // ID of the document to fetch
  final String collectionName = 'sendgrid'; // Name of the collection
  final String fieldName = 'apiKey'; // Name of the field to retrieve
  String apiKeySG = '';

  @override
  void initState() {
    super.initState();
    fetchApiKey();
  }

  Future<void> fetchApiKey() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();
      if (documentSnapshot.exists) {
        apiKeySG = documentSnapshot.get(fieldName);
        print(apiKeySG);
      } else {
        print('Document not found');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> sendRegisterSuccessEmail(
      String recipientEmail, String recipientName) async {
    String apiKey = apiKeySG;
    final Uri uri = Uri.https(
      'api.sendgrid.com',
      '/v3/mail/send',
    );

    final Map<String, dynamic> data = {
      'personalizations': [
        {
          'to': [
            {
              'email': recipientEmail,
              'name': recipientName
            }, // Included recipient's name
          ],
          'subject': 'Thank You for Registering with Mboacare!',
        },
      ],
      'from': {'email': 'mboacare@gmail.com'},
      'content': [
        {
          'type': 'text/plain',
          'value': '''
Dear $recipientName,

Thank you for registering your facility with Mboacare! We have received your details and appreciate your interest in joining our platform.

Our team is currently reviewing the information you've provided to ensure that it aligns with our quality standards. We're committed to creating a network of reliable medical facilities that users can trust. As soon as the review process is complete, we will notify you about the status of your registration.

We appreciate your patience during this process. If you have any questions or need further assistance, please don't hesitate to reach out to us at [contact email or phone number]. We look forward to potentially featuring your hospital on Mboacare and expanding our network of healthcare providers.

Thank you once again for considering Mboacare.

Best regards,
The Mboacare Team
        '''
        },
      ],
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 202) {
      print('Email sent successfully');
    } else {
      print('Failed to send email. Status code: ${response.statusCode}');
    }
  }

  ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  List<ChecklistItem> checklistMedicalServices = [
    ChecklistItem(title: 'Surgery', isChecked: false),
    ChecklistItem(title: 'Paediatrics', isChecked: false),
    ChecklistItem(title: 'Internal Medicine', isChecked: false),
    ChecklistItem(title: 'Obstetrics & Gynaecology', isChecked: false),
    ChecklistItem(title: 'Cardiology', isChecked: false),
    ChecklistItem(title: 'Oncology', isChecked: false),
    ChecklistItem(title: 'Neurology', isChecked: false),
    ChecklistItem(title: 'Other', isChecked: false),
  ];

  void concatenateMedicalServices() {
    String concatenatedItems = '';
    for (var item in checklistMedicalServices) {
      if (item.isChecked) {
        concatenatedItems += '${item.title},';
      }
    }
    if (concatenatedItems.isNotEmpty) {
      concatenatedItems =
          concatenatedItems.substring(0, concatenatedItems.length - 1);
    }
    _hospitalSpecialities = concatenatedItems;
  }

  List<ChecklistItem> checklistFacilities = [
    ChecklistItem(title: 'Emergency Room', isChecked: false),
    ChecklistItem(title: 'Laboratory', isChecked: false),
    ChecklistItem(title: 'Radiology', isChecked: false),
    ChecklistItem(title: 'Pharmacy', isChecked: false),
    ChecklistItem(title: 'Intensive Care Unit', isChecked: false),
    ChecklistItem(title: 'Operation Room', isChecked: false),
    ChecklistItem(title: 'Blood Bank', isChecked: false),
    ChecklistItem(title: 'Other', isChecked: false),
  ];

  void concatenateFacilities() {
    String concatenatedItems = '';
    for (var item in checklistFacilities) {
      if (item.isChecked) {
        concatenatedItems += '${item.title},';
      }
    }
    if (concatenatedItems.isNotEmpty) {
      concatenatedItems =
          concatenatedItems.substring(0, concatenatedItems.length - 1);
    }
    _hospitalFacilities = concatenatedItems;
  }

  List<ChecklistItem> checklistEmergencyService = [
    ChecklistItem(title: 'Ambulance', isChecked: false),
    ChecklistItem(title: '24/7 Emergency Room', isChecked: false),
    ChecklistItem(title: 'Other', isChecked: false),
  ];

  void concatenateEmergencyService() {
    String concatenatedItems = '';
    for (var item in checklistEmergencyService) {
      if (item.isChecked) {
        concatenatedItems += '${item.title},';
      }
    }
    if (concatenatedItems.isNotEmpty) {
      concatenatedItems =
          concatenatedItems.substring(0, concatenatedItems.length - 1);
    }
    _hospitalEmergencyServices = concatenatedItems;
  }

  void _setOtherValue(String name, String value) {
    setState(() {
      switch (name) {
        case 'hospitalType':
          _hospitalType = value;
          break;
        case 'hospitalSize':
          _hospitalSize = value;
          break;
        case 'hospitalOwnership':
          _hospitalOwnership = value;
          break;
        case 'hospitalBedCapacity':
          _hospitalBedCapacity = value;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the dashboard page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        userName: '',
                      )),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hospital Name
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital Name *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter hospital name',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                          ),
                          onSaved: (value) => _hospitalName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hospital name is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Hospital Address
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital Address *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter hospital address',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                          ),
                          onSaved: (value) => _hospitalAddress = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hospital address is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Hospital Phone Number
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital Phone Number *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                          ),
                          onSaved: (value) => _hospitalPhone = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Hospital Email Address
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital Email Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter email address (optional)',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                          ),
                          onSaved: (value) => _hospitalEmail = value,
                        ),
                      ],
                    ),
                  ),
                ),

                // Hospital Website
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital Website',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter website (optional)',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                          ),
                          onSaved: (value) => _hospitalWebsite = value,
                        ),
                      ],
                    ),
                  ),
                ),

                // Specialities for the Hospitals
                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           'Specialities for the Hospitals',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         TextFormField(
                //           decoration: const InputDecoration(
                //             hintText: 'Enter hospital specialities',
                //             border: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Colors.black,
                //                 width: 1.0,
                //               ),
                //             ),
                //             isDense: true,
                //             contentPadding:
                //                 EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 4.0),
                //           ),
                //           onSaved: (value) => _hospitalSpecialities = value,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Medical Services Offered',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: checklistMedicalServices.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title:
                                  Text(checklistMedicalServices[index].title),
                              value: checklistMedicalServices[index].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  checklistMedicalServices[index].isChecked =
                                      value!;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Facilities Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: checklistFacilities.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(checklistFacilities[index].title),
                              value: checklistFacilities[index].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  checklistFacilities[index].isChecked = value!;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Emergency Services Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: checklistEmergencyService.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title:
                                  Text(checklistEmergencyService[index].title),
                              value: checklistEmergencyService[index].isChecked,
                              onChanged: (value) {
                                setState(() {
                                  checklistEmergencyService[index].isChecked =
                                      value!;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // const SizedBox(height: 20),
                // Radio buttons for  Hospital Bed Capacity
                _buildChoiceChipForm(
                  title: 'Bed Capacity *',
                  name: 'hospitalBedCapacity',
                  options: [
                    'less than 50 Beds',
                    '50-100 Beds',
                    'more than 100 beds'
                  ],
                  onChanged: (value) => _hospitalBedCapacity = value,
                ),

                // Radio buttons for Hospital Type
                _buildChoiceChipForm(
                  title: 'Hospital Type *',
                  name: 'hospitalType',
                  options: ['Public', 'Private', 'Other'],
                  onChanged: (value) => _hospitalType = value,
                ),

                // Radio buttons for Hospital Size
                _buildChoiceChipForm(
                  title: 'Hospital Size *',
                  name: 'hospitalSize',
                  options: ['Small', 'Medium', 'Large'],
                  onChanged: (value) => _hospitalSize = value,
                ),

                // Radio buttons for Hospital Ownership
                _buildChoiceChipForm(
                  title: 'Hospital Ownership',
                  name: 'hospitalOwnership',
                  options: ['Individual', 'Corporate', 'Government'],
                  onChanged: (value) => _hospitalOwnership = value,
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Select Image (Optional)',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),

                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 150,
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    concatenateMedicalServices();
                    concatenateFacilities();
                    concatenateEmergencyService();
                    Future.delayed(const Duration(seconds: 1)).then((_) {
                      _submitForm();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  Widget _buildChoiceChipForm({
    required String title,
    required String name,
    required List<String> options,
    void Function(String)? onChanged,
  }) {
    String? selectedOption = _getSelectedOption(name);
    bool showOtherInput = selectedOption == 'Other';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...options.map(
              (option) => Row(
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                        if (onChanged != null) {
                          onChanged(value!);
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(option),
                  if (option == 'Other')
                    if (showOtherInput)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter other...',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _setOtherValue(name, value);
                              });
                            },
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getSelectedOption(String name) {
    switch (name) {
      case 'hospitalType':
        return _hospitalType;
      case 'hospitalSize':
        return _hospitalSize;
      case 'hospitalOwnership':
        return _hospitalOwnership;
      case 'hospitalBedCapacity':
        return _hospitalBedCapacity;
      default:
        return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convert hospitalData to a map
      final hospitalDataMap = {
        'hospitalName': _hospitalName,
        'hospitalAddress': _hospitalAddress,
        'hospitalPhone': _hospitalPhone,
        'hospitalEmail': _hospitalEmail,
        'hospitalWebsite': _hospitalWebsite,
        'hospitalType': _hospitalType,
        'hospitalSize': _hospitalSize,
        'hospitalOwnership': _hospitalOwnership,
        'hospitalSpecialities': _hospitalSpecialities,
        'hospitalFacilities': _hospitalFacilities,
        'hospitalBedCapacity': _hospitalBedCapacity,
        'hospitalEmergencyServices': _hospitalEmergencyServices
      };

      // CollectionReference for the hospitals collection in Cloud Firestore
      final CollectionReference _hospitalsRef =
          FirebaseFirestore.instance.collection('hospitals');

      try {
        if (_selectedImage != null) {
          // Upload the selected image to Firebase Storage
          //   final Reference storageReference = FirebaseStorage.instance
          //       .ref()
          //       .child(
          //           'hospital_images/${DateTime.now().millisecondsSinceEpoch}');
          //   final UploadTask uploadTask =
          //       storageReference.putFile(_selectedImage!);
          //   final TaskSnapshot storageTaskSnapshot =
          //       await uploadTask.whenComplete(() {});
          //   final String downloadUrl =
          //       await storageTaskSnapshot.ref.getDownloadURL();
          //   hospitalDataMap['hospitalImageUrl'] =
          //       downloadUrl; // Add the download URL to the map
          //               // Save hospital data to Cloud Firestore
          // await _hospitalsRef.add(hospitalDataMap);
          final Reference storageReference = FirebaseStorage.instance
              .ref()
              .child(
                  'hospital_images/${DateTime.now().millisecondsSinceEpoch}');

          final UploadTask uploadTask =
              storageReference.putFile(_selectedImage!);
          TaskSnapshot storageTaskSnapshot = await uploadTask;

          if (uploadTask.snapshot.state == TaskState.success) {
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            print("Download URL: $downloadUrl");

            hospitalDataMap['hospitalImageUrl'] = downloadUrl;
            // Add other data to hospitalDataMap

            // Save hospital data to Cloud Firestore
            await _hospitalsRef.add(hospitalDataMap);

            print("Hospital data saved successfully.");
          } else {
            print("Image upload task failed.");
          }
        } else {
          // Save hospital data to Cloud Firestore
          hospitalDataMap['hospitalImageUrl'] = '';
          await _hospitalsRef.add(hospitalDataMap);
        }
        if (_hospitalEmail!.isNotEmpty) {
          sendRegisterSuccessEmail(_hospitalEmail!, _hospitalName!);
        }
        // Show a snackbar indicating successful form submission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear the form fields and selected image after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _selectedImage = null;
        });

        // Add hospital data to the HospitalProvider
        // final hospitalProvider =
        //     Provider.of<HospitalProvider>(context, listen: false);
        // hospitalProvider.addHospital(HospitalData(
        //   hospitalName: _hospitalName!,
        //   hospitalAddress: _hospitalAddress!,
        //   hospitalSpecialities: _hospitalSpecialities!,
        //   hospitalImageUrl: hospitalDataMap['hospitalImageUrl'],
        // ));
        Future.delayed(const Duration(seconds: 1)).then((_) {
          // Navigate to the HospitalDashboard screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HospitalDashboard(),
            ),
          );
        });
      } catch (e) {
        print('Error saving data to Cloud Firestore: $e');
        // Show an error message if there's an issue with data saving
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving data. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

class ChecklistItem {
  String title;
  bool isChecked;

  ChecklistItem({required this.title, required this.isChecked});
}
