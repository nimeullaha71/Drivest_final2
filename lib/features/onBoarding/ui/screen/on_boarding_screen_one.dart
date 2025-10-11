import 'package:drivest_office/features/onBoarding/ui/screen/on_boarding_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/asset_paths.dart';

class OnBoardingScreenOne extends StatefulWidget {
  const OnBoardingScreenOne({super.key});

  @override
  State<OnBoardingScreenOne> createState() => _OnBoardingScreenOneState();

  static Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OnBoardingScreenOneState extends State<OnBoardingScreenOne> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF015093),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),

                // Logo Section
                SizedBox(
                  height: size.height * 0.35,
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPaths.appLogoSvg,
                      height: size.height * 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome to Divest",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  "Search the dreamy car in Belgium",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OnBoardingScreenOne._buildDot(true),
                    OnBoardingScreenOne._buildDot(false),
                    OnBoardingScreenOne._buildDot(false),
                    OnBoardingScreenOne._buildDot(false),
                  ],
                ),

                SizedBox(height: size.height * 0.12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnBoardingScreenTwo(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF015093),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
