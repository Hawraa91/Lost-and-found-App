import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationTrackerPage extends StatefulWidget {
  @override
  _LocationTrackerPageState createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Position> _lastFiveLocations = [];
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    // Request permission to access the user's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case where the user denies location permission
      return;
    }

    // Listen for location updates
    _positionStream = Geolocator.getPositionStream().listen((Position position) {
      _updateLastFiveLocations(position);
    });
  }

  void _updateLastFiveLocations(Position position) {
    setState(() {
      _lastFiveLocations.add(position);
      if (_lastFiveLocations.length > 5) {
        _lastFiveLocations.removeAt(0);
      }
      _saveLocationsToFirebase();
    });
  }

  Future<void> _saveLocationsToFirebase() async {
    for (Position position in _lastFiveLocations) {
      await _firestore.collection('locations').add({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Last 5 Locations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ..._lastFiveLocations.map((position) {
              return Text(
                'Lat: ${position.latitude}, Lng: ${position.longitude}',
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}