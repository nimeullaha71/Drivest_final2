import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool saveCard = true;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Card information",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 10),

            // 🔹 Card Number, Expiry, CVC
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "1234 1234 1234 1234",
                      border: InputBorder.none,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/visa.png', height: 22),
                          const SizedBox(width: 5),
                          Image.asset('assets/images/card_icon.png', height: 22),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "MM / YY",
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "CVC",
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.credit_card, color: Colors.grey[400]),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("Cardholder name",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Full name on card",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Country or region",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              value: "United States",
              items: const [
                DropdownMenuItem(value: "United States", child: Text("United States")),
                DropdownMenuItem(value: "Canada", child: Text("Canada")),
                DropdownMenuItem(value: "United Kingdom", child: Text("United Kingdom")),
              ],
              onChanged: (val) {},
            ),

            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "ZIP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: saveCard,
                  onChanged: (val) {
                    setState(() {
                      saveCard = val ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const Text("save this card for future payments",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 25),

            // 🔹 Pay Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: primaryColor.withOpacity(0.4),
                  elevation: 8,
                ),
                child: const Text(
                  "Pay \$100",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
