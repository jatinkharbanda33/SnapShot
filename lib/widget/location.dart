import 'dart:convert';
import 'dart:io';
import 'package:favplaces/models/place.dart';
import 'package:favplaces/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class takelocation extends StatefulWidget {
  const takelocation({super.key, required this.setlocation});
  final void Function(PlaceLocation _itslocation) setlocation;

  @override
  State<takelocation> createState() => _takelocationState();
}

class _takelocationState extends State<takelocation> {
  PlaceLocation? _pickedlocation;
  bool _gettinglocation = false;
  String get getimage {
    if (_pickedlocation == null) return '';
    final lat = _pickedlocation!.latitude;
    final lon = _pickedlocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyBNrliwZO8-nAE_ef51MhECBgDZhZEBKoY';
  }

  Future<void> savelocation(double lat, double lon) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=AIzaSyBNrliwZO8-nAE_ef51MhECBgDZhZEBKoY');
    final response = await http.get(url);
    final jsondata = json.decode(response.body);
    final adress = jsondata['results'][0]['formatted_address'];

    setState(() {
      _pickedlocation = PlaceLocation(
          latitude: lat.toDouble(), longitude: lon.toDouble(), address: adress);
    });
    widget.setlocation(_pickedlocation!);
  }

  void onselectlocation() async {
    final getloc = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: ((context) => MapScreen())));
    if (getloc == null) return;
    savelocation(getloc.latitude, getloc.longitude);
  }

  void getcurrentlocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _gettinglocation = true;
    });

    _locationData = await location.getLocation();
    setState(() {
      _gettinglocation = false;
    });
    final lat = _locationData.latitude;
    final lon = _locationData.longitude;
    if (lat == null || lon == null) return;
    savelocation(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (_gettinglocation) {
      content = const CircularProgressIndicator();
    }
    if (_pickedlocation != null) {
      content = Image.network(
        getimage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor.withOpacity(0.2))),
          alignment: Alignment.center,
          child: Center(
            child: content,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: getcurrentlocation,
                icon: Icon(Icons.location_on),
                label: Text("Current Location")),
            TextButton.icon(
                onPressed: onselectlocation,
                icon: Icon(Icons.map),
                label: Text("Choose from map")),
          ],
        )
      ],
    );
  }
}
