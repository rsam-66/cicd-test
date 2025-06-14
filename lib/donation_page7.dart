import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'donation_page1.dart';
import 'donation_page3.dart';
import 'bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DonationPage7 extends StatefulWidget {
  final String metodePembayaran;
  final int nominal;
  final String namaDonasi;

  const DonationPage7({
    Key? key,
    required this.metodePembayaran,
    required this.nominal,
    this.namaDonasi = 'Kebakaran di Kalimantan Selatan',
  }) : super(key: key);

  @override
  State<DonationPage7> createState() => _DonationPage7State();
}

class _DonationPage7State extends State<DonationPage7> {
  Map<String, dynamic>? donation;
  bool isLoading = true;
  bool isSuccess = false;

  bool get isQRIS => widget.metodePembayaran == 'QRIS';

  @override
  void initState() {
    super.initState();
    if (isQRIS) {
      isSuccess = true;
    }
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

  String getTanggal() {
    final now = DateTime.now();
    return DateFormat('d MMMM y - HH:mm', 'id_ID').format(now);
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

  Future<void> KembaliHalamanDonasi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('donationID');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        title: const Text('Donasi Anda'),
        backgroundColor: const Color(0xFF6D93B0),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 80,
                      color: isSuccess ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isSuccess
                          ? 'Pembayaran Berhasil!'
                          : 'Pembayaran Diproses',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSuccess
                          ? 'Terima Kasih Atas Dukungan Anda!'
                          : 'Pembayaran kamu via pembayaran (instan/virtual account) sedang diverifikasi',
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildBox('Tanggal', getTanggal()),
              _buildBox('Metode Pembayaran', widget.metodePembayaran),
              _buildBox(
                'Nominal Donasi',
                'Rp. ${_formatCurrency(widget.nominal)}',
              ),
              const SizedBox(height: 16),
              _buildDonasiInfo(context),
              const SizedBox(height: 16),
              if (!isSuccess && !isQRIS)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSuccess = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D93B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Perbarui Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: OutlinedButton(
                onPressed: () {KembaliHalamanDonasi(context);},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali ke Halaman Donasi',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDonasiInfo(BuildContext context) {
  if (donation == null) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            donation!['donationPicture'],
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          donation!['donationTitle'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(donation!['donationRaiser'], style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DonationPage3()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Donasi Lagi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}


  String _formatCurrency(int amount) {
    final str = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (match) => '.');
  }
}
