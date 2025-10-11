import 'dart:io';
import 'package:drivest_office/features/auth/screen/sign_up_screen.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/asset_paths.dart';
import '../services/auth_service.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      bool success = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
        );
      } else {
        _showError("Invalid email or password");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onGoogleSignIn() async {
    _showError("Google Sign-In এখনো চালু হয়নি");
  }

  Future<void> _onAppleSignIn() async {
    _showError("Apple Sign-In এখনো চালু হয়নি");
  }

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ForgotPasswordScreen(email: _emailController.text.trim()),
      ),
    );
  }

  void _onSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.replaceAll("Exception: ", ""),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 🔷 Header Section
            Container(
              color: const Color(0xFF004E92),
              width: double.infinity,
              height: size.height * 0.45,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => exit(0),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        AssetPaths.appLogoSvg,
                        height: size.height * 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔶 Form Section
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Welcome to Drivest",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Drive the deal you deserve",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter email"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter password"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() =>
                              _obscurePassword = !_obscurePassword);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) =>
                                    setState(() => _rememberMe = val!),
                                activeColor: const Color(0xFF004E92),
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          GestureDetector(
                            onTap: _onForgotPassword,
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Sign in button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004E92),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _onSignIn,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Google Sign-In
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _onGoogleSignIn,
                          icon: SvgPicture.asset('assets/images/google.svg'),
                          label: const Text("Sign in with Google"),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Apple Sign-In
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _onAppleSignIn,
                          icon: SvgPicture.asset('assets/images/apple.svg'),
                          label: const Text("Sign in with Apple"),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign up
                      GestureDetector(
                        onTap: _onSignUp,
                        child: const Text.rich(
                          TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 15),
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(
                                  color: Color(0xFF015093),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
