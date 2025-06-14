import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'donation_page2.dart';

class Donation {
  final int id;
  final String title;
  final String imageUrl;
  final int amountRaised;
  final int daysLeft;
  final int goalAmount;
  final String raiser;

  Donation({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.amountRaised,
    required this.daysLeft,
    required this.goalAmount,
    required this.raiser,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['donationID'],
      title: json['donationTitle'],
      imageUrl: json['donationPicture'],
      amountRaised: json['amountRaised'],
      daysLeft: json['daysLeft'],
      goalAmount: json['goalAmount'],
      raiser: json['donationRaiser'],
    );
  }
}


class DonationPage1 extends StatefulWidget {
  const DonationPage1({super.key});

  @override
  _DonationPage1State createState() => _DonationPage1State();
}

class _DonationPage1State extends State<DonationPage1> {
  late Future<List<Donation>> futureDonations;

  @override
  void initState() {
    super.initState();
    futureDonations = fetchDonations();
  }

  Future<List<Donation>> fetchDonations() async {
    final response = await http.get(Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/getDonations'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List donations = data['donasis'];
      return donations.map((json) => Donation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load donations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D93B0),
        title: const Text('Donation'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Donation>>(
        future: futureDonations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No donations available.'));
          }

          final donations = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              final progress = donation.goalAmount > 0
                  ? donation.amountRaised / donation.goalAmount
                  : 0.0;

              return GestureDetector(
                onTap: () async {
                  // Simpan donationID ke SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt('donationID', donation.id);

                  // Navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationPage2()), // ganti sesuai page Anda
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        donation.imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 150,
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donation.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(donation.raiser),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Terkumpul'),
                                    Text(
                                      'Rp. ${donation.amountRaised}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text('Sisa Hari'),
                                    Text(
                                      '${donation.daysLeft}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 4,
                              backgroundColor: Colors.grey,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6D93B0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
