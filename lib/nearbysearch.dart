import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _mapController;
  final GooglePlace _googlePlace =
      GooglePlace(dotenv.env['PLACES_API_KEY'].toString());

  double _searchRadius = 1000;
  double _afterSearchRadius = 0;
  final double _minRadius = 1000;
  final double _maxRadius = 15000;
  Set<Marker> _marketMarkers = {};

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
  }

  Future<Set<Marker>> _createMarketMarker(Position position) async {
    Set<Marker> marketMarkers = {};
    NearBySearchResponse searchResponse = await _googlePlace.search
        .getNearBySearch(
            Location(lat: position.latitude, lng: position.longitude),
            _searchRadius.toInt(),
            type: "supermarket");

    if (searchResponse == null)
      return Future.error("Search not valid");
    else {
      if (searchResponse.results == null)
        return Future.error("No results found");
      else {
        searchResponse.results.forEach((places) {
          marketMarkers.add(Marker(
              markerId: MarkerId(places.placeId),
              position: LatLng(
                places.geometry.location.lat,
                places.geometry.location.lng,
              ),
              infoWindow: InfoWindow(title: places.name)));
        });
      }
    }
    return marketMarkers;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final Future<Position> _currentPosition = _getCurrentPosition();
    return FutureBuilder(
      future: _currentPosition,
      builder: (context, AsyncSnapshot<Position> snapshot) {
        // snapshot.
        return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text('주변 마트 검색'),
                backgroundColor: Colors.green[700],
              ),
              body: snapshot.hasData
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text("Sliders"),
                            Slider(
                                value: _searchRadius,
                                max: _maxRadius,
                                min: _minRadius,
                                divisions: (_maxRadius - _minRadius) ~/ 500,
                                onChanged: (value) {
                                  setState(() {
                                    _searchRadius = value;
                                  });
                                }),
                            Text("검색 반경 : " +
                                _searchRadius.round().toString() +
                                "m"),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                Set<Marker> results =
                                    await _createMarketMarker(snapshot.data);
                                setState(() {
                                  _marketMarkers = results;
                                  _afterSearchRadius = _searchRadius;
                                });
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            markers: _marketMarkers.union(<Marker>{
                              Marker(
                                  markerId: MarkerId("Here"),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueGreen),
                                  position: LatLng(snapshot.data.latitude,
                                      snapshot.data.longitude),
                                  infoWindow: InfoWindow(title: "현재 위치")),
                              // Marker(
                              //   markerId: MarkerId("Center"),
                              //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                              //   position:
                              // )
                            }),
                            initialCameraPosition: CameraPosition(
                              target: LatLng(snapshot.data.latitude,
                                  snapshot.data.longitude),
                              zoom: 15.0,
                            ),
                            circles: <Circle>{
                              Circle(
                                  circleId: CircleId("Search Redius"),
                                  radius: _afterSearchRadius,
                                  center: LatLng(snapshot.data.latitude,
                                      snapshot.data.longitude),
                                  fillColor: Colors.blue.withOpacity(0.5),
                                  strokeWidth: 1),
                            },
                          ),
                        ),
                      ],
                    )
                  : Text("Current Position is not loaded, cannot open map.")),
        );
      },
    );
  }
}

class Circles {}
