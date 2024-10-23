import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

class ReadJson {
  Future<Map<String, dynamic>> readJson() async {
    final String response =
        await rootBundle.rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    return data;
  }
}

class MedicalApp extends StatelessWidget {
  final ReadJson readJson = ReadJson();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: readJson.readJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          final data = snapshot.data ?? {};
          return Scaffold(
            appBar: AppBar(
              title: Text('Medical App'),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationSection(),
                    SizedBox(height: 16),
                    SearchBar(),
                    SizedBox(height: 16),
                    SpecialistDoctorsBanner(),
                    SizedBox(height: 16),
                    CategoriesSection(),
                    SizedBox(height: 16),
                    NearbyMedicalCentersSection(
                      centers: List<Map<String, dynamic>>.from(data['centers']),
                    ),
                    SizedBox(height: 16),
                    DoctorListSection(
                      doctors: List<Map<String, dynamic>>.from(data['doctors']),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class LocationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Location',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text('Seattle, USA', style: TextStyle(fontSize: 16)),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search doctor...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}

class SpecialistDoctorsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blueAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Looking for Specialist Doctors?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Increased font size for the title
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Schedule an appointment with our top doctors.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.white54),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 8, color: Colors.white),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 8, color: Colors.white54),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/doctor4.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Dentistry',
      'icon': Icons.medical_services,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Cardiology',
      'icon': Icons.favorite,
      'color': Colors.redAccent,
    },
    {
      'name': 'Pulmonology',
      'icon': Icons.air,
      'color': Colors.lightBlueAccent,
    },
    {
      'name': 'General',
      'icon': Icons.local_hospital,
      'color': Colors.greenAccent,
    },
    {
      'name': 'Neurology',
      'icon': Icons.psychology,
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Laborator',
      'icon': Icons.science,
      'color': Colors.deepPurpleAccent,
    },
    {
      'name': 'Gastroente..',
      'icon': Icons.health_and_safety,
      'color': Colors.pinkAccent,
    },
    {
      'name': 'Vaccinate',
      'icon': Icons.vaccines,
      'color': Colors.tealAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: categories[index]['color'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    categories[index]['icon'],
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(categories[index]['name']!),
              ],
            );
          },
        ),
      ],
    );
  }
}

class NearbyMedicalCentersSection extends StatelessWidget {
  final List<Map<String, dynamic>> centers;

  NearbyMedicalCentersSection({required this.centers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Medical Centers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: centers.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(right: 10),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4)),
                          image: DecorationImage(
                            image: AssetImage(centers[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          centers[index]['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(centers[index]['address']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 16),
                            SizedBox(width: 5),
                            Text(
                                '${centers[index]['rating']} (${centers[index]['reviews']})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DoctorListSection extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;

  DoctorListSection({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${doctors.length} founds',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Default', style: TextStyle(fontSize: 16)),
                Icon(Icons.sort),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Doctor Image
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            doctors[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctors[index]['name']!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(doctors[index]['specialty']!,
                                style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 4),
                            Text(doctors[index]['clinic']!,
                                style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 16),
                                SizedBox(width: 4),
                                Text(doctors[index]['rating']!),
                                SizedBox(width: 8),
                                Text('(${doctors[index]['reviews']})',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.favorite_border, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MedicalApp(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
