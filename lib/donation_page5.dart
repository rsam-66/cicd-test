import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'donation_page7.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DonationPage5 extends StatefulWidget {
  final String metodePembayaran;
  final int nominal;

  const DonationPage5({
    Key? key,
    required this.metodePembayaran,
    required this.nominal,
  }) : super(key: key);

  @override
  _DonationPage5State createState() => _DonationPage5State();
}

class _DonationPage5State extends State<DonationPage5> {
  Map<String, dynamic>? donation;
  final String nomorPengguna = '0812345678';
  String? userName;
  String? userEmail;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _dukunganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  bool get isQRIS => widget.metodePembayaran == 'QRIS';
  bool get isVA => widget.metodePembayaran.contains('Virtual Account');

  String getNomorVA() {
    final nomor = nomorPengguna.replaceFirst('0', '');
    if (widget.metodePembayaran.contains('BCA')) return '807778$nomor';
    if (widget.metodePembayaran.contains('Mandiri')) return '880178$nomor';
    if (widget.metodePembayaran.contains('BRI')) return '888108$nomor';
    if (widget.metodePembayaran.contains('BNI')) return '822708$nomor';
    return '-';
  }

  String getIconPath() {
    if (widget.metodePembayaran.contains('GO-PAY')) return 'asset/ikongopay.png';
    if (widget.metodePembayaran.contains('QRIS')) return 'asset/ikonqris.png';
    if (widget.metodePembayaran.contains('Shopeepay')) return 'asset/ikonshopeepay.png';
    if (widget.metodePembayaran.contains('DANA')) return 'asset/ikondana.png';
    if (widget.metodePembayaran.contains('BCA')) return 'asset/ikonbca.png';
    if (widget.metodePembayaran.contains('Mandiri')) return 'asset/ikonmandiri.png';
    if (widget.metodePembayaran.contains('BRI')) return 'asset/ikonbri.png';
    if (widget.metodePembayaran.contains('BNI')) return 'asset/ikonbni.png';
    return '';
  }

  String getBatasWaktu() {
    final now = DateTime.now().add(const Duration(days: 1));
    return DateFormat('EEEE, d MMMM y HH:mm', 'id_ID').format(now) + ' WIB';
  }

  Future<void> createDonationTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final donationId = prefs.getInt('donationID'); // Ambil donationID juga

    if (userId == null || donationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User atau Donasi tidak ditemukan')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/createTransaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': userId,
        'donationID': donationId,
        'totalAmount': widget.nominal,
        'methodName': widget.metodePembayaran,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('✅ Transaksi berhasil dikirim');
    } else {
      print('❌ Gagal membuat transaksi: ${response.body}');
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

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) throw Exception('User ID not found.');

      final response = await http.post(
        Uri.parse('https://rizzhoma-mobile-app.onrender.com/api/getDataUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][0];
        setState(() {
          userName = data['username'];
          userEmail = data['email'];
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        title: const Text('Kebakaran di Kalimantan Selatan'),
        backgroundColor: const Color(0xFF6D93B0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBox('Batas Waktu Pembayaran', getBatasWaktu()),
          const SizedBox(height: 12),
          _buildBox(
            'Konfirmasi Nominal Donasi',
            'Rp. ${NumberFormat.decimalPattern('id_ID').format(widget.nominal)}',
          ),
          const SizedBox(height: 12),
          _buildPaymentBox(),
          const SizedBox(height: 12),
          if (!isQRIS && !isVA) _buildBox(userName ?? '-', nomorPengguna),
          if (isVA) _buildVABox(context),
          const SizedBox(height: 12),
          if (!isQRIS) _buildSupportBox(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SizedBox(
          height: 55,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await createDonationTransaction();
              updateAmount();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationPage7(
                    metodePembayaran: widget.metodePembayaran,
                    nominal: widget.nominal,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Lanjut Pembayaran',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildBox(String title, String content) {
    final bool isNominal = title == 'Konfirmasi Nominal Donasi';
    return Container(
      padding: const EdgeInsets.all(12),
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
            style: TextStyle(
              fontSize: isNominal ? 20 : 16,
              fontWeight: isNominal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(getIconPath(), width: 40, height: 40),
          const SizedBox(width: 12),
          Text(
            widget.metodePembayaran,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVABox(BuildContext context) {
    String nomorVA = getNomorVA();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nomor Virtual Account',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  nomorVA,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: nomorVA));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nomor VA disalin')),
                  );
                },
              ),
            ],
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
      child: TextField(
        controller: _dukunganController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Sertakan dukungan (Opsional)',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
