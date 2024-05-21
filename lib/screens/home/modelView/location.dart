import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

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
    _scheduleLocationDeletion();
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

  // Location updated every 3 minutes
  void _handleLocationUpdate(Position position) {
    _updateLastFiveLocations(position);
  }

  void _updateLastFiveLocations(Position position) {
    final currentTime = DateTime.now();
    if (_lastLocationTimestamp == null ||
        currentTime.difference(_lastLocationTimestamp!).inMinutes >= 4) {
      setState(() {
        _lastFiveLocations.add(position);
        if (_lastFiveLocations.length > 5) {
          _lastFiveLocations.removeAt(0);
        }
        _saveLocationsToFirebase();
        _lastLocationTimestamp = currentTime; // Update the last recorded timestamp
      });
    }
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

  void _scheduleLocationDeletion() {
    Timer.periodic(Duration(minutes: 30), (timer) async {
      final tenMinutesAgo = DateTime.now().subtract(Duration(minutes: 30));
      final expiredLocations = await _firestore
          .collection('locations')
          .where('timestamp', isLessThan: tenMinutesAgo)
          .get();

      for (final doc in expiredLocations.docs) {
        await doc.reference.delete();
      }
    });
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Last 5 Locations:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('locations')
                      .where('timestamp', isGreaterThan: DateTime.now().subtract(Duration(minutes: 10)))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final documents = snapshot.data!.docs.reversed.toList();
                    final lastFiveDocuments = documents.take(5).toList();

                    return Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(4),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Lat',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Long',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Date&Time',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Google Maps',
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
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () => _openGoogleMaps(doc['latitude'], doc['longitude']),
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                                    ),
                                  ),
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
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
