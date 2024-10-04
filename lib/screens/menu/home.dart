import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final double lat;
  final double lng;

  const Home(this.lat, this.lng, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
