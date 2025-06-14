import 'package:flutter/material.dart';
import 'donation_page5.dart';
import 'donation_page6.dart';

class DonationPage4 extends StatefulWidget {
  final int nominal;
  const DonationPage4({Key? key, required this.nominal}) : super(key: key);

  @override
  State<DonationPage4> createState() => _DonationPage4State();
}

class _DonationPage4State extends State<DonationPage4> {
  String? selectedPayment;

  final List<Map<String, String>> instantPayments = [
    {'icon': 'asset/ikongopay.png', 'label': 'GO-PAY'},
    {'icon': 'asset/ikonqris.png', 'label': 'QRIS'},
    {'icon': 'asset/ikonshopeepay.png', 'label': 'Shopeepay'},
    {'icon': 'asset/ikondana.png', 'label': 'DANA'},
  ];

  final List<Map<String, String>> vaPayments = [
    {'icon': 'asset/ikonbca.png', 'label': 'BCA Virtual Account'},
    {'icon': 'asset/ikonmandiri.png', 'label': 'Mandiri Virtual Account'},
    {'icon': 'asset/ikonbri.png', 'label': 'BRI Virtual Account'},
    {'icon': 'asset/ikonbni.png', 'label': 'BNI Virtual Account'},
  ];

  void _selectPayment(String label) {
    setState(() {
      selectedPayment = label;
    });
  }

  Widget _buildPaymentItem(String icon, String label) {
    bool isSelected = selectedPayment == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isSelected
                ? const Color(0xFF6D93B0).withOpacity(0.1)
                : Colors.white,
        border: Border.all(
          color: isSelected ? const Color(0xFF6D93B0) : Colors.black12,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _selectPayment(label),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF6D93B0) : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF6D93B0)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EED9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D93B0),
        title: const Text('Pilih Metode Pembayaran'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pembayaran instan (verifikasi otomatis, minimal nominal Rp.10.000)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children:
                  instantPayments
                      .map(
                        (payment) => _buildPaymentItem(
                          payment['icon']!,
                          payment['label']!,
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Virtual account (verifikasi otomatis, minimal nominal Rp. 10.000)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children:
                  vaPayments
                      .map(
                        (payment) => _buildPaymentItem(
                          payment['icon']!,
                          payment['label']!,
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed:
              selectedPayment != null
                  ? () {
                    if (selectedPayment == 'QRIS') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DonationPage6(
                                metodePembayaran: selectedPayment!,
                                nominal: widget.nominal,
                                nomorPengguna: '0812345678',
                              ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DonationPage5(
                                metodePembayaran: selectedPayment!,
                                nominal: widget.nominal,
                              ),
                        ),
                      );
                    }
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedPayment != null
                    ? const Color(0xFF6D93B0)
                    : Colors.white,
            foregroundColor:
                selectedPayment != null ? Colors.white : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color:
                    selectedPayment != null
                        ? const Color(0xFF6D93B0)
                        : Colors.black,
              ),
            ),
          ),
          child: const Text(
            'Lanjut',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
