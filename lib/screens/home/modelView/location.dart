import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../components/bottomNavBar.dart';

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
      if (_shouldRecordLocation(position)) {
        _updateLastFiveLocations(position);
        _lastLocationTimestamp = currentTime;
      }
    }
  }

  bool _shouldRecordLocation(Position newPosition) {
    if (_lastFiveLocations.isEmpty) {
      return true;
    }

    // Calculate the distance between the last recorded location and the new location
    double distanceInMeters = Geolocator.distanceBetween(
      _lastFiveLocations.last.latitude,
      _lastFiveLocations.last.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    // Record the location if the distance is greater than 100 meters
    return distanceInMeters >= 100;
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

                return Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(4),
                  },
                  children: [
                    const TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Latitude',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Longitude',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Timestamp',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (final doc in lastFiveDocuments)
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(doc['latitude'].toString(), style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(doc['longitude'].toString(), style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(doc['timestamp'].toDate().toString(), style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
