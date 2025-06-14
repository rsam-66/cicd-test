import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'donation_page4.dart';

class DonationPage3 extends StatefulWidget {
  const DonationPage3({Key? key}) : super(key: key);

  @override
  State<DonationPage3> createState() => _DonationPage3State();
}

class _DonationPage3State extends State<DonationPage3>
    with SingleTickerProviderStateMixin {
  final List<int> nominalList = [10000, 20000, 30000, 50000, 70000, 100000];
  int? selectedNominal;
  final TextEditingController _manualController = TextEditingController();
  bool _isManualInvalid = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _formatManualInput(String value) {
    String cleaned = value.replaceAll('.', '').replaceAll(',', '');
    int parsed = int.tryParse(cleaned) ?? 0;
    String formatted = NumberFormat.decimalPattern('id').format(parsed);

    _manualController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _validateManualInput(formatted);
  }

  void _validateManualInput(String value) {
    final parsed = int.tryParse(value.replaceAll('.', '')) ?? 0;
    if (parsed < 10000) {
      setState(() {
        _isManualInvalid = true;
      });
      _shakeController.forward(from: 0);
    } else {
      setState(() {
        _isManualInvalid = false;
      });
    }
  }

  bool get isButtonActive {
    final manual =
        int.tryParse(_manualController.text.replaceAll('.', '')) ?? 0;
    return selectedNominal != null || (manual >= 10000);
  }

  int get finalNominal {
    if (selectedNominal != null) {
      return selectedNominal!;
    } else {
      return int.tryParse(_manualController.text.replaceAll('.', '')) ?? 0;
    }
  }

  void _selectNominal(int nominal) {
    setState(() {
      selectedNominal = nominal;
      _manualController.clear();
      _isManualInvalid = false;
    });
  }

  void _focusManualInput() {
    setState(() {
      selectedNominal = null;
    });
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Masukkan Nominal Donasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...nominalList.map((nominal) {
                  final isSelected = selectedNominal == nominal;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color:
                          isSelected ? const Color(0xFF6D93B0) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () => _selectNominal(nominal),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF6D93B0)
                                      : Colors.black,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp. ${NumberFormat.decimalPattern('id').format(nominal)}',
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: isSelected ? 18 : 16,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 8),
                const Text(
                  'Masukkan Donasi Lainnya',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    final offset =
                        8.0 *
                        (1 - _shakeController.value) *
                        (_isManualInvalid
                            ? (1 - (_shakeController.value * 2) % 2)
                            : 0);
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: TextField(
                        onTap: _focusManualInput,
                        controller: _manualController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          hintText: '0',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  _isManualInvalid ? Colors.red : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: _formatManualInput,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Min. donasi sebesar Rp10.000',
                  style: TextStyle(
                    color: _isManualInvalid ? Colors.red : Colors.grey,
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
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed:
              isButtonActive
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DonationPage4(nominal: finalNominal),
                      ),
                    );
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isButtonActive ? const Color(0xFF6D93B0) : Colors.white,
            foregroundColor: isButtonActive ? Colors.white : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isButtonActive ? const Color(0xFF6D93B0) : Colors.black,
              ),
            ),
          ),
          child: const Text(
            'Lanjut Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
