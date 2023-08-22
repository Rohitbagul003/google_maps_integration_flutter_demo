import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:merlin_foyer_app/ui/home/home_screen.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:merlin_foyer_app/utility/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MerlinColors.darkColor,
      child: Center(
        child: SvgPicture.asset(
          MerlinImg.logo,
          width: 45,
          height: 45,
        ),
      ),
    );
  }
}
