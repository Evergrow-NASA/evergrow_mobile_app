import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:evergrow_mobile_app/screens/menu/select_location.dart';
import 'package:evergrow_mobile_app/screens/menu/start_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evergrow',
      theme: ThemeData(
         textTheme: GoogleFonts.openSansTextTheme(
      Theme.of(context).textTheme,
    ),
        fontFamily: 'OpenSans',
        splashColor: Colors.transparent,
      ),
      
      debugShowCheckedModeBanner: false,
      initialRoute: '/location',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const StartMenu();
            break;
          case '/location':
            builder = (BuildContext context) => const SelectLocation();
            break;
          case '/home':
            builder = (BuildContext context) =>const Home( -12.0464, -77.0428);

          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}