import 'package:flutter/material.dart';
import '../pages/services/network/trade_analysis_api.dart';

class TradeAnalysisWidget extends StatefulWidget {
  final Map<String, dynamic> carData; // incoming car data from details screen

  const TradeAnalysisWidget({super.key, required this.carData});

  @override
  State<TradeAnalysisWidget> createState() => _TradeAnalysisWidgetState();
}

class _TradeAnalysisWidgetState extends State<TradeAnalysisWidget> {
  bool loading = true;
  Map<String, dynamic>? analysis;

  @override
  void initState() {
    super.initState();
    fetchAnalysis();
  }

  Future<void> fetchAnalysis() async {
    try {
      final response = await TradeAnalysisAPI.analyzeCar(widget.carData);
      setState(() {
        analysis = response[0];
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (analysis == null) {
      return const Text("No analysis available.", style: TextStyle(color: Colors.red));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _row("Suggested Price", "\$${analysis!["estimated_market_value"]}"),
          _row("Estimated Costs", "\$${analysis!["total_costs"]}"),
          _row("Expected Profit", "\$${analysis!["expected_profit"]}"),
          _row("Profit Margin", "${analysis!["profit_margin_pct"]}%"),
          _row("Risk Level", analysis!["risk_level"]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xffEAF2FA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              analysis!["recommendation"],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff015093),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
