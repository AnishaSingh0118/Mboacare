class Hospital {
  final String name;
  final String specialty;
  final String image;
  final List<String> keywords;

  Hospital({
    required this.name,
    required this.specialty,
    required this.image,
    required this.keywords,
  });
}

final List<Hospital> hospitals = [
  Hospital(
    name: "AIIMS",
    specialty: "General Medicine",
    image: "lib/assests/images/aiims.jpg",
    keywords: ["General", "Surgery"],
  ),
  Hospital(
    name: "Apollo",
    specialty: "Cardiology",
    image: "lib/assests/images/apollo.jpg",
    keywords: ["Cardiology", "Surgery"],
  ),
  Hospital(
    name: "CMC",
    specialty: "Cardiology",
    image: "lib/assests/images/CMC.jpg",
    keywords: ["Cardiology", "Surgery"],
  ),
  Hospital(
    name: "Max Hospital",
    specialty: "Cardiology",
    image: "lib/assests/images/Max.jpg",
    keywords: ["Cardiology", "Surgery"],
  ),
  Hospital(
    name: "Medanta",
    specialty: "Cardiology",
    image: "lib/assests/images/medanta.jpg",
    keywords: ["Cardiology", "Surgery"],
  ),
  Hospital(
    name: "PGIMER",
    specialty: "Cardiology",
    image: "lib/assests/images/PGIMR.jpg",
    keywords: ["Cardiology", "Surgery"],
  ),
];
