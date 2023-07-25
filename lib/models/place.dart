import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'dart:io';

const idd = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.title, required this.itsiamge, required this.location})
      : id = idd.v4();
  final String id;
  final String title;
  final File itsiamge;
  final PlaceLocation location;
}
