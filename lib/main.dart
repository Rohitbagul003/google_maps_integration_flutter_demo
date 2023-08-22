import 'package:flutter/material.dart';
import 'package:merlin_foyer_app/resource/states/bottom_nav_state.dart';
import 'package:merlin_foyer_app/resource/states/map_state.dart';
import 'package:merlin_foyer_app/ui/splash/splash_screen.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavState>(create: (_) => BottomNavState()),
        ChangeNotifierProvider<MapState>(create: (_) => MapState()),
      ],
      child: MaterialApp(
        title: 'Foyer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MerlinColors.primaryColor),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
