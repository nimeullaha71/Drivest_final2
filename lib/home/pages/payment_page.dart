import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/services/network/subscription_service.dart'; // only works on web

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => token = prefs.getString('token'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscribe to Continue")),
      body: Center(
        child: token == null
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your free trial has expired.\nPlease subscribe to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await SubscriptionService.createSubscription(context);
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004E92),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Subscribe Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StripePaymentWebView extends StatelessWidget {
  final String url;
  const StripePaymentWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (pageUrl) {
            if (pageUrl.contains("success")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Successful")),
              );
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      );

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: WebViewWidget(controller: controller),
    );
  }
}
