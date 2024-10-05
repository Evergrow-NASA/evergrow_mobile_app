import 'package:flutter/material.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
       body: Center(
        child: ElevatedButton(
          onPressed: () {
              Navigator.pushNamed(context, '/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 195, 23, 23),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Home'),
          ),
        ),
    );
  }
}
