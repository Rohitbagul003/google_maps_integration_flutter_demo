import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:merlin_foyer_app/resource/states/bottom_nav_state.dart';
import 'package:merlin_foyer_app/resource/states/map_state.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:merlin_foyer_app/utility/extensions.dart';
import 'package:merlin_foyer_app/utility/size_configs.dart';
import 'package:provider/provider.dart';

import '../../../utility/utility.dart';
import 'custom_navigation.dart';

class BottomNavBar extends StatelessWidget with Utility {
  const BottomNavBar({Key? key}) : super(key: key);

  TextStyle _labelStyle({bool isSelected = false}) {
    return isSelected
        ? const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)
        : TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: MerlinColors.textGray400);
  }

  Widget _navigationBar(BottomNavState bottomNavState) {
    return CustomBottomNavigationBar(
      height: 65,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      currentIndex: bottomNavState.selectedIndex,
      onSelected: (int index) {
        bottomNavState.setSelectedIndex = index;
      },
      elevation: 20,
      items: [
        CustomBottomNavigationBarItem(
          selectedIcon: _selectedIcon(
            icon: "Images.gradientColorMail",
            title: 'Maps',
            widgetIcon: Icon(Icons.map, color: MerlinColors.primaryColor),
            isSelected: true,
          ),
          unSelectedIcon: _selectedIcon(
            icon: '',
            title: 'Maps',
            widgetIcon: Icon(Icons.map, color: MerlinColors.textGray400),
            isSelected: false,
          ),
        ),
        CustomBottomNavigationBarItem(
          selectedIcon: _selectedIcon(
            icon: "Images.gradientColorMail",
            title: 'Profile',
            widgetIcon: Icon(Icons.person, color: MerlinColors.primaryColor),
            isSelected: true,
          ),
          unSelectedIcon: _selectedIcon(
            icon: '',
            title: 'Profile',
            widgetIcon: Icon(Icons.person, color: MerlinColors.textGray400),
            isSelected: false,
          ),
        ),
      ],
    );
  }

  Widget _selectedIcon({
    required String icon,
    Widget? widgetIcon,
    required String title,
    bool isSelected = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        widgetIcon ?? SvgPicture.asset(icon),
        heightBox10(),
        Text(
          title,
          style: _labelStyle(isSelected: isSelected),
        ),
        heightBox5(),
      ],
    ).hP8;
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Consumer2<BottomNavState, MapState>(
      builder: (context, bottomNavState, mapState, _) {
        return SizedBox(
          height: mapState.addMarkersToggle ? 105 : 65,
          child: Column(
            children: [
              if (mapState.addMarkersToggle)
                Container(
                  height: 40,
                  width: sizeConfig.screenWidth,
                  color: MerlinColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(
                    "Please select a location to add as a profile",
                    style: TextStyle(color: MerlinColors.textGray400),
                  ),
                ),
              _navigationBar(bottomNavState),
            ],
          ),
        );
      },
    );
  }
}
