import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'donation_page3.dart';

class DonationPage2 extends StatefulWidget {
  const DonationPage2({super.key});

  @override
  _DonationPage2State createState() => _DonationPage2State();
}

class _DonationPage2State extends State<DonationPage2> {
  Map<String, dynamic>? donation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonationDetail();
  }

  Future<void> fetchDonationDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final donationID = prefs.getInt('donationID');

    if (donationID == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/getDataDonation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'donationID': donationID}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        donation = data['data'][0];
        isLoading = false;
      });
      print('donation: $donation');
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (donation == null) {
      return const Scaffold(
        body: Center(child: Text("Donasi tidak ditemukan")),
      );
    }

    double progress = 0.0;
    if (donation!['goalAmount'] > 0) {
      progress = donation!['amountRaised'] / donation!['goalAmount'];
    }

    return Scaffold(
  backgroundColor: const Color(0xFFF3EED9),
  body: ListView(
    children: [
      Stack(
        children: [
          Image.network(
            donation!['donationPicture'],
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              donation!['donationTitle'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation!['donationTitle'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp. ${donation!['amountRaised']}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${donation!['daysLeft']} Hari',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (donation!['amountRaised'] / donation!['goalAmount']).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6D93B0),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Terkumpul dari Rp. ${donation!['goalAmount']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(Icons.favorite, '22', 'Donasi'),
                          _buildStatItem(
                            Icons.new_releases,
                            '3',
                            'Kabar Terbaru',
                          ),
                          _buildStatItem(
                            Icons.handshake,
                            '3',
                            'Pencairan Dana',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.nature, size: 40, color: Colors.green),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation!['donationRaiser'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('Identitas Terverifikasi'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
  bottomNavigationBar: Container(
    height: 80,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
    ),
    child: Row(
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share, color: Color(0xFF6D93B0), size: 24),
          label: const Text(
            'Bagikan',
            style: TextStyle(
              color: Color(0xFF6D93B0),
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF6D93B0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonationPage3()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text(
              'Donasi Sekarang',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);


  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink),
        const SizedBox(height: 4),
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
