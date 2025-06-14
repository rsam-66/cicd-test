import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'news.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? userMessage;
  bool isLoading = true;
  String? errorMessage;
  String? carbonFootprint;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchCarbonFootprint();
  }

  Future<void> fetchCarbonFootprint() async {
    final url = Uri.parse('https://charting.numberlens.com/api/teamearth/getdailyco2?authtoken=D43026302F294A5784F7512A8969FE37');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          carbonFootprint = jsonResponse['CurrentIndexValueDisplay'];
        });
      } else {
        print('Failed to load carbon data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching carbon data: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User ID not found.');
      }

      final response = await http.post(
        Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/getDataUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][0];

        setState(() {
          userName = data['username'];
          userMessage = data['message'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: $errorMessage')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: Colors.blue[300],
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset('asset/tree_drawing.png', width: 50, height: 50),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $userName',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text('Welcome!', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Donate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsPage()),
                        );
                      },
                      child: const Text('News'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Stack(
              children: [
                Image.asset(
                  'asset/pollution.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    'How can we help the world?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  'Carbon Footprint',
                  carbonFootprint ?? 'Loading...',  // nilai API
                  Colors.blue[200]!,
                ),
                _buildStatCard(
                  'AQI - BANDUNG',
                  '61',
                  Colors.yellow[700]!,
                ),
              ],
            ),
            SizedBox(height: 16),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
    ),
    child: Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildPlantCard(String title) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            color: Colors.green[100],
            child: Icon(Icons.nature, size: 50),
          ),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
          ElevatedButton(onPressed: () {}, child: Text('Plant')),
        ],
      ),
    );
  }

  Widget _buildActionBox(String title, String subtitle) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
