import 'dart:io';

class HospitalData {
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalSpecialities;
  final String? hospitalImageUrl;
  final String? hospitalWebsite;

  HospitalData({
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalSpecialities,
    this.hospitalImageUrl,
    this.hospitalWebsite,
  });
}
