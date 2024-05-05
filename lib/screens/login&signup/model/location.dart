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
  DateTime? _lastLocationTimestamp;

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
      _handleLocationUpdate(position);
    });
  }

  void _handleLocationUpdate(Position position) {
    final currentTime = DateTime.now();
    if (_lastLocationTimestamp == null || currentTime.difference(_lastLocationTimestamp!).inMinutes >= 3) {
      _updateLastFiveLocations(position);
      _lastLocationTimestamp = currentTime;
    }
  }

  void _updateLastFiveLocations(Position position) {
    if (_lastFiveLocations.isNotEmpty &&
        _lastFiveLocations.last.latitude == position.latitude &&
        _lastFiveLocations.last.longitude == position.longitude) {
      // The new position is the same as the last one, so we don't need to update
      return;
    }

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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('locations').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final documents = snapshot.data!.docs.reversed.toList();
                final lastFiveDocuments = documents.take(5).toList();

                return Column(
                  children: lastFiveDocuments.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final latitude = data['latitude'] as double;
                    final longitude = data['longitude'] as double;
                    final timestamp = data['timestamp'] as Timestamp;

                    return Text(
                      'Lat: $latitude, Lng: $longitude, Timestamp: ${timestamp.toDate()}',
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}