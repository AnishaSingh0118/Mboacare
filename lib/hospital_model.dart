import 'dart:io';

class HospitalData {
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalSpecialities;
  final String hospitalImageUrl;
  final String? hospitalWebsite;
  final String? hospitalEmail;
  final String? hospitalPhone;
  final String hospitalFacilities;
  final String? hospitalBedCapacity;
  final String? hospitalEmergencyServices;

  HospitalData(
      {required this.hospitalName,
      required this.hospitalAddress,
      required this.hospitalSpecialities,
      required this.hospitalImageUrl,
      this.hospitalWebsite,
      this.hospitalEmail,
      this.hospitalPhone,
      required this.hospitalFacilities,
      this.hospitalBedCapacity,
      this.hospitalEmergencyServices});
}
