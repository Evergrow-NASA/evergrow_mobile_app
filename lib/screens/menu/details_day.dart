import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';
import '../../components/top_section.dart';

class DetailsDay extends StatefulWidget {
  final DateTime selectedDay;
  final bool isDroughtSelected;
  final bool isIntenseRainSelected;
  final bool isFrostSelected;
  final bool isStrongWindsSelected;

  const DetailsDay({
    super.key,
    required this.selectedDay,
    required this.isDroughtSelected,
    required this.isIntenseRainSelected,
    required this.isFrostSelected,
    required this.isStrongWindsSelected,
  });

  @override
  State<DetailsDay> createState() => _DetailsDayState();
}

class _DetailsDayState extends State<DetailsDay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const TopSection(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeatherHeader(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildWeatherHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Weather Calendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
