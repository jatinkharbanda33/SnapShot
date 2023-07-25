import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as systum;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, File xyz, PlaceLocation mm) async {
    final appDir = await systum.getApplicationDocumentsDirectory();
    final filename = path.basename(xyz.path);
    final updatedimage = await xyz.copy('${appDir.path}/$filename');
    final newPlace = Place(title: title, itsiamge: updatedimage, location: mm);
    state = [newPlace, ...state];
    final dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbpath, 'places.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE user_place(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)'),
      version: 1,
    );
    db.insert('_userplace', {
      'id': newPlace.id,
      'title':newPlace.title,
      'image':newPlace.itsiamge.path,
      'lat':newPlace.location.latitude,
      'lon':newPlace.location.longitude,
      'address':newPlace.location.address
    });
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
