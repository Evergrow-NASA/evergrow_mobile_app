import 'package:evergrow_mobile_app/screens/menu/select_location.dart';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class LocationRow extends StatelessWidget {
  final String location;

  const LocationRow({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectLocation()),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, color: AppTheme.primaryColor), 
        ],
      ),
    );
  }
}
