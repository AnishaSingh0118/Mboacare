import 'package:flutter/material.dart';
import 'package:mboacare/chip_widget.dart';
import 'package:mboacare/colors.dart';
import 'package:mboacare/hospital_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class HospitalDetailsPage extends StatelessWidget {
  final HospitalData hospital;
  HospitalDetailsPage({super.key, required this.hospital});
  String email = 'Email';
  String phone = 'Phone';
  String address = 'Address';


  Future<void> _launchURL(String url) async {
    print('Launching URL: $url');

    if (url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'))) {
      try {
        final Uri uri = Uri.parse(url);
        // if (Uri) {
        await url_launcher.launchUrl(uri);
        // } else {
        //   print('Could not launch $url');
        // }
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      print('Invalid URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    address = hospital.hospitalAddress;
    email = hospital.hospitalEmail ?? '';
    phone = hospital.hospitalPhone ?? '';
    final specalities = hospital.hospitalSpecialities
        .split(',')
        .map((item) => item.trim())
        .toList();
    final facilities = hospital.hospitalFacilities
        ?.split(',')
        .map((item) => item.trim())
        .toList();
    final emergency = hospital.hospitalEmergencyServices
        ?.split(',')
        .map((item) => item.trim())
        .toList();
    final bedCapacity = hospital.hospitalBedCapacity;
    return Scaffold(
      appBar: AppBar(title: const Text("Hospital Details")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: hospital.hospitalImageUrl != ''
                              ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              hospital.hospitalImageUrl,
                            ),
                          )
                              : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'lib/assests/images/placeholder_image.png',
                            ),
                          )),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: MediaQuery.sizeOf(context).width * .3,
                    child: GestureDetector(
                        onTap: () => _launchURL(hospital.hospitalWebsite!),
                        child: hospital.hospitalWebsite != ''
                            ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.text,
                          ),
                          padding: const EdgeInsets.all(3),
                          height: 40,
                          width: 150,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.language_outlined,
                              //   color: Colors.white,
                              // ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Text(
                                'Visit Website',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                            : Container()),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                hospital.hospitalName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text),
                    ),
                  )),
              const SizedBox(height: 10),
              // Email Box
              InkWell(
                onTap: (){
                  final Uri mail = Uri(path: email, scheme: 'mailto');
                  url_launcher.launchUrl(mail);
                },
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: AppColors.text,
                      hintText: email,
                      hintStyle: const TextStyle(color: AppColors.text),
                      labelStyle: const TextStyle(color: AppColors.primaryColor),
                      border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Phone',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text),
                    ),
                  )),
              const SizedBox(height: 10),
              // Phone Box
              InkWell(
                onTap: ()async{
                  final Uri tel = Uri(scheme:'tel', path: phone);
                  if(await url_launcher.canLaunchUrl(tel)){
                    await url_launcher.launchUrl(tel);
                  }
                },
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      prefixIconColor: AppColors.text,
                      hintText: phone,
                      hintStyle: const TextStyle(color: AppColors.text),
                      labelStyle: const TextStyle(color: AppColors.primaryColor),
                      border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text),
                    ),
                  )),
              const SizedBox(height: 10),
              // Address Box
              InkWell(
                onTap: ()async{

                  String query = Uri.encodeComponent(address);
                  final Uri mapAddress = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
                  if( await url_launcher.canLaunchUrl(mapAddress)){
                    await url_launcher.launchUrl(mapAddress);
                  }
                  // else if (await url_launcher.canLaunchUrl(mapAddress)) {
                  // await url_launcher.launchUrl(mapAddress, mode:url_launcher.LaunchMode.externalApplication);
                  // }
                },
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      prefixIconColor: AppColors.text,
                      hintText: address,
                      hintStyle: const TextStyle(color: AppColors.text),
                      labelStyle: const TextStyle(color: AppColors.primaryColor),
                      border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Services And Facilities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Services Offered : ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.text,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children: specalities.map((item) {
                      return ChipWidget(item);
                    }).toList()),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Facilities : ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.text,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: facilities?.length != 0
                      ? Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: facilities!.map((item) {
                        return ChipWidget(item);
                      }).toList())
                      : Container()),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Emergency Services : ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.text,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: emergency?.length != 0
                      ? Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: emergency!.map((item) {
                        return ChipWidget(item);
                      }).toList())
                      : Container()),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Bed Capacity : ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.text,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: ChipWidget(bedCapacity ?? '')),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}