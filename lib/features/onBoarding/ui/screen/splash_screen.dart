import 'package:flutter/material.dart';
import '../widget/app_logo.dart';
import 'on_boarding_screen_one.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _goToOnboardingScreenOne();
    });
  }

  Future<void> _goToOnboardingScreenOne()async{
    await Future.delayed(const Duration(seconds: 2),);
    if(!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OnBoardingScreenOne(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF015093),
      body: SafeArea(
        child: Center(
          child: AppLogo(),
        ),
          ),
        );
     }
}
