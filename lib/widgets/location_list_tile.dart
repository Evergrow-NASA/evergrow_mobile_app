import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap:
              0, // Controla el espacio entre el leading y el título
          contentPadding:
              EdgeInsets.zero, // Elimina el padding extra si es necesario
          leading: SvgPicture.asset("assets/icons/location_pin.svg"),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: secondary2,
        ),
      ],
    );
  }
}
