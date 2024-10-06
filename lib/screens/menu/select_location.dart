// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:evergrow_mobile_app/models/autocomplete_prediction.dart';
import 'package:evergrow_mobile_app/services/map_service.dart';
import 'package:evergrow_mobile_app/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/constants.dart';
import 'package:evergrow_mobile_app/screens/menu/home.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  List<AutocompletePrediction> predictions = [];
  final TextEditingController _searchController = TextEditingController();

  LatLng? destLocation = const LatLng(40.7128, -74.0060);
  Position? destLocationUser;
  loc.Location location = loc.Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _address;
  bool _showLocationPredictions = false;
  bool _updatingFromMap = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    getCurrentLocation();

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty && !_updatingFromMap) {
        setState(() {
          if (destLocation ==
              LatLng(destLocationUser!.latitude, destLocationUser!.longitude)) {
            _showLocationPredictions = false;
          } else {
            _showLocationPredictions = true;
          }
        });
      } else {
        setState(() {
          _showLocationPredictions = false;
        });
      }
      placeAutoComplete(_searchController.text);
    });
  }

  Future<void> _initializeLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        destLocationUser = position;
        destLocation =
            LatLng(destLocationUser!.latitude, destLocationUser!.longitude);
      });

      final GoogleMapController? controller = await _controller.future;
      if (controller != null) {
        controller.animateCamera(CameraUpdate.newLatLng(destLocation!));
      }

      getAddressFromLatLng();
      print('Address: $destLocation');
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
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
      String formattedAddress = result['result']['formatted_address'];

      setState(() {
        _searchController.text = formattedAddress;
        predictions.clear();
        _showLocationPredictions = false;
        _address = formatAddress(formattedAddress);
      });

      final GoogleMapController? controller = await _controller.future;
      controller?.animateCamera(CameraUpdate.newLatLng(newLocation));

      setState(() {
        destLocation = newLocation;
      });
    }
  }

  String formatAddress(String address) {
    List<String> parts = address.split(',');
    if (parts.isNotEmpty) {
      return parts.sublist(1).join(',').trim();
    }
    return address;
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: destLocation!.latitude,
        longitude: destLocation!.longitude,
        googleMapApiKey: apiKey,
      );

      setState(() {
        _address = formatAddress(data.address);
      });
    } catch (e) {
      print(e);
    }
  }

  getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    final GoogleMapController? controller = await _controller.future;

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    if (permissionGranted == loc.PermissionStatus.granted) {
      location.changeSettings(accuracy: loc.LocationAccuracy.high);

      _currentPosition = await location.getLocation();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getMap(),
              _buildContainerSelectLocation(),
            ],
          ),
          if (!_showLocationPredictions) _getPickIcon(),
          _getCloseIcon(),
        ],
      ),
    );
  }

  Widget _getMap() {
    return Expanded(
      child: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: destLocation!,
          zoom: 16,
        ),
        onCameraMove: (CameraPosition? position) {
          if (destLocation != position!.target) {
            setState(() {
              _updatingFromMap = true;
              destLocation = position.target;
              _searchController.text = _address ?? 'Select your location';
            });
          }
        },
        onCameraIdle: () {
          getAddressFromLatLng();
          setState(() {
            _updatingFromMap = false;
          });
        },
        onTap: (latLng) {
          print(latLng);
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Widget _getPickIcon() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 350.0),
        child: Image.asset(
          'assets/icons/pick.png',
          height: 45,
          width: 45,
        ),
      ),
    );
  }

  Widget _getCloseIcon() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0),
        child: GestureDetector(
          onTap: () {
            if (predictions.isEmpty) {
              Navigator.pushNamed(context, '/');
            } else {
              setState(() {
                _showLocationPredictions = false;
                predictions.clear();
              });
            }
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
      ),
    );
  }

  Widget _buildContainerSelectLocation() {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double containerHeight = _showLocationPredictions ? 740 : 250;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      height: containerHeight - keyboardHeight,
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
          _buildTextField(),
          const SizedBox(height: 10),
          if (_showLocationPredictions)
            Expanded(
              child: _buildLocationList(),
            ),
          const SizedBox(height: 20),
          if (!_showLocationPredictions) _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildLocationList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: predictions.length,
      itemBuilder: (context, index) {
        return LocationListTile(
          location: predictions[index].description!,
          press: () {
            setState(() {
              _searchController.text = predictions[index].description!;
              _showLocationPredictions = false;
            });
            _selectLocation(predictions[index].placeId!);
          },
        );
      },
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        onTap: () {
          setState(() {
            _showLocationPredictions = true;
          });
        },
        onChanged: (value) {
          if (value.isNotEmpty && !_updatingFromMap) {
            placeAutoComplete(value);
          } else {
            setState(() {
              _showLocationPredictions = false;
            });
          }
        },
        controller: _searchController,
        onFieldSubmitted: (value) async {
          if (predictions.isNotEmpty) {
            String placeId = predictions.first.placeId!;
            await _selectLocation(placeId);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Home(
                  destLocation!.latitude,
                  destLocation!.longitude,
                  _address ?? 'Unknown Location',
                ),
              ),
              (route) => false,
            );
          }
        },
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
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
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
                  destLocation!.longitude,
                  _address ?? 'Unknown Location',
                ),
              ),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
    );
  }
}
