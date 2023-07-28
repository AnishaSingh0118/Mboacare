import 'package:flutter/material.dart';
import 'hospital.dart';
import 'hospitaldetails.dart';
import 'signUpPage.dart';
import 'colors.dart';

class Dashboard extends StatefulWidget {
  final String? userName; // New parameter to accept the user's name

  Dashboard({this.userName}); // Updated constructor

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _searchQuery = "";
  String _selectedFilter = "View All";

  List<Hospital> filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredHospitals with all hospitals when the widget is first built
    filteredHospitals = hospitals;
  }

  void _filterHospitals() {
    setState(() {
      filteredHospitals = hospitals
          .where((hospital) =>
              _selectedFilter == "View All" ||
              hospital.specialty == _selectedFilter)
          .where((hospital) =>
              _searchQuery.isEmpty ||
              hospital.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              hospital.keywords.any(
                  (keyword) => keyword.contains(_searchQuery.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Dashboard'),
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.search, color: Colors.green),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _filterHospitals();
                        },
                        decoration: InputDecoration(
                          hintText: "Search hospitals...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterText("View All"),
                  _buildFilterText("General Medicine"),
                  _buildFilterText("Surgery"),
                  _buildFilterText("Cardiology"),
                  _buildFilterText("Brain"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hi, ${widget.userName ?? 'Guest'}!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                      _filterHospitals();
                    });
                  },
                  dropdownColor: Colors.white,
                  items: <String>[
                    "View All",
                    "General Medicine",
                    "Surgery",
                    "Cardiology",
                    "Brain",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.green)),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHospitals.length,
                itemBuilder: (context, index) {
                  Hospital hospital = filteredHospitals[index];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _navigateToDetailsPage(hospital);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hospital Image
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(hospital.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Hospital Name with arrow button
                              Container(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          hospital.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildArrowButton(hospital),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Specialty
                                    Text(
                                      hospital.specialty,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Feature Boxes
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            _buildFeatureBox(
                                              "General Medicine",
                                              Colors.blue.withOpacity(0.03),
                                            ),
                                            SizedBox(width: 8),
                                            _buildFeatureBox(
                                              "Cardiology",
                                              Colors.red.withOpacity(0.03),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterText(String filter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
          _filterHospitals();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          filter,
          style: TextStyle(
            color: _selectedFilter == filter ? Colors.green : Colors.black,
            fontWeight:
                _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.buttonColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.buttonColor,
        ),
      ),
    );
  }

  Widget _buildArrowButton(Hospital hospital) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _navigateToDetailsPage(hospital);
        },
        splashColor: Colors.green.withOpacity(0.5),
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetailsPage(Hospital hospital) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HospitalDetailsPage(hospital: hospital),
      ),
    );
  }
}
