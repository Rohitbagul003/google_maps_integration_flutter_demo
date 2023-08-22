import 'package:flutter/material.dart';
import 'package:merlin_foyer_app/resource/states/bottom_nav_state.dart';
import 'package:merlin_foyer_app/ui/common-widgets/bnb/bottom_nav_bar.dart';
import 'package:merlin_foyer_app/ui/map-screen/map_screen.dart';
import 'package:merlin_foyer_app/ui/profile/profile_screen.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> screens = [
    const MapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavState>(
      builder: (context, bnbState, _) {
        return Scaffold(
          backgroundColor: MerlinColors.darkColor,
          body: screens[bnbState.selectedIndex],
          bottomNavigationBar: const SafeArea(
            child: BottomNavBar(),
          ),
        );
      },
    );
  }
}
