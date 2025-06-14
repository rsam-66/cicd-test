import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'donation_page7.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DonationPage6 extends StatefulWidget {
  final String metodePembayaran;
  final int nominal;
  final String nomorPengguna;
  final String dukungan;

  const DonationPage6({
    Key? key,
    required this.metodePembayaran,
    required this.nominal,
    required this.nomorPengguna,
    this.dukungan = '',
  }) : super(key: key);

  @override
  State<DonationPage6> createState() => _DonationPage6State();
}

class _DonationPage6State extends State<DonationPage6> {
  Map<String, dynamic>? donation;
  bool isLoading = false;

  String getBatasWaktu() {
    final now = DateTime.now().add(const Duration(days: 1));
    return DateFormat('EEEE, d MMMM y HH:mm', 'id_ID').format(now) + ' WIB';
  }

  Future<void> postTransactionDetail() async {
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

  Future<void> updateAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final donationID = prefs.getInt('donationID');

    if (donationID == null) return;

    final response = await http.post(
      Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/updateAmount'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'donationID': donationID,
        'amount': widget.nominal, 
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        donation = data['data'][0];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        title: const Text('Instruksi Pembayaran'),
        backgroundColor: const Color(0xFF6D93B0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBox('Batas Waktu Pembayaran', getBatasWaktu()),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Image.asset('asset/ikonqris.png', width: 80),
                const SizedBox(height: 16),
                Image.asset(
                  'asset/QR_code_donation.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                _buildBox(
                  'Nominal Donasi',
                  'Rp. ${NumberFormat.decimalPattern('id_ID').format(widget.nominal)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildSupportBox(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed: () {
            updateAmount();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DonationPage7(
                      metodePembayaran: widget.metodePembayaran,
                      nominal: widget.nominal,
                    ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D93B0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cek Status',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Sertakan dukungan (Opsional)',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
