import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hospital_model.dart';

class HospitalProvider with ChangeNotifier {
  List<HospitalData> _hospitals = [];
  List<HospitalData> _filteredHospitals = [];
  String _selectedFilter = 'View All'; // Initialize with 'View All'

  List<HospitalData> get hospitals => _hospitals;
  List<HospitalData> get filteredHospitals => _filteredHospitals;
  String get selectedFilter => _selectedFilter;

  // Constructor to initialize the HospitalProvider with data
  HospitalProvider() {
    _fetchHospitalsFromFirestore();
  }

  // Stream that listens for changes in the Firestore collection
  Stream<List<HospitalData>> getHospitalsStream() {
    return FirebaseFirestore.instance.collection('hospitals').snapshots().map(
      (querySnapshot) {
        List<HospitalData> hospitals = [];
        querySnapshot.docs.forEach((doc) {
          final hospital = HospitalData(
            hospitalName: doc.get('hospitalName') ?? '',
            hospitalAddress: doc.get('hospitalAddress') ?? '',
            hospitalSpecialities: doc.get('hospitalSpecialities') ?? '',
            hospitalImageUrl: doc.get('hospitalImageUrl') ?? '',
            hospitalWebsite: doc.get('hospitalWebsite') ?? '',
            hospitalEmail: doc.get('hospitalEmail') ?? '',
            hospitalPhone: doc.get('hospitalPhone') ?? '',
            hospitalBedCapacity: doc.get('hospitalBedCapacity') ?? '',
            hospitalFacilities: doc.get('hospitalFacilities') ?? '',
            hospitalEmergencyServices:
                doc.get('hospitalEmergencyServices') ?? '',
            // Add other fields if needed
          );
          //print(hospital.hospitalImageUrl);
          hospitals.add(hospital);
        });
        return hospitals;
      },
    );
  }

  void filterHospitals(String query) {
    print('Filtering hospitals with query: $query');
    _filteredHospitals = applyFilters(_hospitals, query, _selectedFilter);
    notifyListeners();
  }

  List<HospitalData> applyFilters(
      List<HospitalData> hospitals, String query, String selectedFilter) {
    final filteredHospitals = hospitals.where((hospital) {
      final nameMatches =
          hospital.hospitalName.toLowerCase().contains(query.toLowerCase());
      final addressMatches =
          hospital.hospitalAddress.toLowerCase().contains(query.toLowerCase());
      final specialitiesMatch = hospital.hospitalSpecialities
          .toLowerCase()
          .contains(query.toLowerCase());
      final facilitiesMatch = hospital.hospitalFacilities
          .toLowerCase()
          .contains(query.toLowerCase());
      // Check if the hospital matches the selected filter
      final filterMatches = selectedFilter == 'View All' ||
          hospital.hospitalSpecialities
              .toLowerCase()
              .contains(selectedFilter.toLowerCase()) ||
          hospital.hospitalFacilities
              .toLowerCase()
              .contains(selectedFilter.toLowerCase());

      return (nameMatches ||
              addressMatches ||
              specialitiesMatch ||
              facilitiesMatch) &&
          filterMatches;
    }).toList();

    return filteredHospitals;
  }

  void setSelectedFilter(String filterOption) {
    _selectedFilter = filterOption;
    notifyListeners();
  }

  void addHospital(HospitalData hospital) async {
    // Convert hospital data to a map
    final hospitalDataMap = {
      'hospitalName': hospital.hospitalName,
      'hospitalAddress': hospital.hospitalAddress,
      'hospitalSpecialities': hospital.hospitalSpecialities,
      'hospitalImagePath': hospital.hospitalImageUrl,
      // Add other fields if needed
    };

    try {
      // Save hospital data to Cloud Firestore
      await FirebaseFirestore.instance
          .collection('hospitals')
          .add(hospitalDataMap);

      // You can also add the hospital to the local list to display it immediately
      _hospitals.add(hospital);
      _filteredHospitals.add(hospital);

      notifyListeners();
    } catch (e) {
      print('Error saving data to Cloud Firestore: $e');
    }
  }

  void _fetchHospitalsFromFirestore() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('hospitals').get();

      _hospitals = [];
      querySnapshot.docs.forEach((doc) {
        final hospital = HospitalData(
          hospitalName: doc.get('hospitalName') ?? '',
          hospitalAddress: doc.get('hospitalAddress') ?? '',
          hospitalSpecialities: doc.get('hospitalSpecialities') ?? '',
          hospitalImageUrl: doc.get('hospitalImageUrl') ?? '',
          hospitalWebsite: doc.get('hospitalWebsite') ?? '',
          hospitalEmail: doc.get('hospitalEmail') ?? '',
          hospitalPhone: doc.get('hospitalPhone') ?? '',
          hospitalBedCapacity: doc.get('hospitalBedCapacity') ?? '',
          hospitalFacilities: doc.get('hospitalFacilities') ?? '',
          hospitalEmergencyServices: doc.get('hospitalEmergencyServices') ?? '',
          // Add other fields if needed
        );
        _hospitals.add(hospital);
      });

      // Set filteredHospitals to all hospitals initially
      _filteredHospitals = _hospitals;

      // Print the first hospital's image URL to check if it's retrieved correctly
      if (_hospitals.isNotEmpty) {
        print('First hospital image URL: ${_hospitals[0].hospitalImageUrl}');
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching data from Cloud Firestore: $e');
    }
  }

  // Method to update filtered hospitals based on selected filter tab
  void updateFilteredHospitals(List<HospitalData> hospitals) {
    if (_selectedFilter == 'View All') {
      _filteredHospitals = hospitals;
    } else {
      _filteredHospitals = hospitals
          .where((hospital) => hospital.hospitalSpecialities
              .toLowerCase()
              .contains(_selectedFilter.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void updateFilteredHospitalsDropdown(List<HospitalData> hospitals) {
    if (_selectedFilter == 'View All') {
      _filteredHospitals = hospitals;
    } else {
      _filteredHospitals = hospitals
          .where((hospital) => hospital.hospitalFacilities
              .toLowerCase()
              .contains(_selectedFilter.toLowerCase()))
          .toList();
      print('Drop : ${_filteredHospitals.length}');
    }
    notifyListeners();
  }
}
