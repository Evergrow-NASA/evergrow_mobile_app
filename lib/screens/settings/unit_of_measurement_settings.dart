import 'package:evergrow_mobile_app/components/top_section.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';
import 'package:flutter/material.dart';

class UnitOfMeasurementSettingsPage extends StatefulWidget {
  const UnitOfMeasurementSettingsPage({super.key});

  @override
  State<UnitOfMeasurementSettingsPage> createState() =>
      _UnitOfMeasurementSettingsPageState();
}

class _UnitOfMeasurementSettingsPageState
    extends State<UnitOfMeasurementSettingsPage> {
  bool _isCelciusSelected = false;
  bool _isKilometersSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          'Unit of measurement settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Temperature',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('Celcius (ºC)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: true,
                              groupValue: _isCelciusSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCelciusSelected = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Ferenheit (ºF)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: false,
                              groupValue: _isCelciusSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCelciusSelected = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Temperature',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text('Kilometers per hour (km/h)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: true,
                              groupValue: _isKilometersSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isKilometersSelected = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Miles per hour (mph)',
                                style: TextStyle(fontSize: 18)),
                            trailing: Radio<bool>(
                              value: false,
                              groupValue: _isKilometersSelected,
                              activeColor: AppTheme.primaryColor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isKilometersSelected = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
