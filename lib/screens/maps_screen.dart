import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.itslocation =
          const PlaceLocation(latitude: 37.422131, longitude: -122.084801, address: ''),
      this.isselecting = false});
  final PlaceLocation itslocation;
  final bool isselecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(!widget.isselecting ? 'Pick your location' : 'Your Location'),
        actions: [
          if (!widget.isselecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedlocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (pos) {
          setState(() {
            _pickedlocation = pos;
          });
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.itslocation.latitude, widget.itslocation.longitude),
            zoom: 16),
        markers: _pickedlocation == null && widget.isselecting
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedlocation ??
                      LatLng(widget.itslocation.latitude,
                          widget.itslocation.longitude),
                ),
              },
      ),
    );
  }
}
