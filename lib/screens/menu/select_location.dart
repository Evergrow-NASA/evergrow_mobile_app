import 'dart:async';

import 'package:evergrow_mobile_app/models/autocomplete_prediction.dart';
import 'package:evergrow_mobile_app/services/map_service.dart';
import 'package:evergrow_mobile_app/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/constants.dart';
import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  List<AutocompletePrediction> predictions = [];
  final TextEditingController _searchController = TextEditingController();

  LatLng? destLocation = const LatLng(40.7128, -74.0060);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _address;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    _searchController.addListener(() {
      placeAutoComplete(_searchController.text);
    });
  }

  void placeAutoComplete(String text) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": text,
      "key": apiKey,
    });

    String? response = await MapService.fetchUrl(uri);

    if (response != null) {
      var result = json.decode(response);
      if (result['predictions'] != null) {
        setState(() {
          predictions = (result['predictions'] as List)
              .map((e) => AutocompletePrediction.fromJson(e))
              .toList();
        });
      }
    }
  }

  Future<void> _selectLocation(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/details/json", {
      "place_id": placeId,
      "key": apiKey,
    });

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      var location = result['result']['geometry']['location'];
      LatLng newLocation = LatLng(location['lat'], location['lng']);

      setState(() {
        _searchController.text = result['result']['formatted_address'];
        predictions.clear();
      });

      final GoogleMapController? controller = await _controller.future;
      controller?.animateCamera(CameraUpdate.newLatLng(newLocation));

      setState(() {
        destLocation = newLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: destLocation!,
                    zoom: 16,
                  ),
                  onCameraMove: (CameraPosition? position) {
                    if (destLocation != position!.target) {
                      setState(() {
                        destLocation = position.target;
                        _searchController.text =
                            _address ?? 'Select your location';
                      });
                    }
                  },
                  onCameraIdle: () {
                    print('camera idle');
                    getAddressFromLatLng();
                  },
                  onTap: (latLng) {
                    print(latLng);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Container(
                  height: 300.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select your location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          onChanged: (value) {
                            placeAutoComplete(value);
                          },
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: secondary3,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) => LocationListTile(
                            press: () {
                              _selectLocation(predictions[index].placeId!);
                            },
                            location: predictions[index].description!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: neutral,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => Home(
                                      destLocation!.latitude,
                                      destLocation!.longitude),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 350.0),
              child: Image.asset(
                'assets/icons/pick.png',
                height: 45,
                width: 45,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: neutral,
                    width: 2.0,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: neutral,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: destLocation!.latitude,
          longitude: destLocation!.longitude,
          googleMapApiKey: apiKey);
      setState(() {
        _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    final GoogleMapController? controller = await _controller.future;

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (permissionGranted == loc.PermissionStatus.granted) {
      location.changeSettings(accuracy: loc.LocationAccuracy.high);

      // Get the location of the user
      _currentPosition = await location.getLocation();

      // Move the camera to the user's location
      controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
        zoom: 16,
      )));
      setState(() {
        destLocation =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      });
    }
  }
}
