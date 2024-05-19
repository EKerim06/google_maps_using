import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

//https://routes.googleapis.com/directions/v2:computeRoutes

class DirectionPage extends StatefulWidget {
  const DirectionPage({super.key});

  @override
  State<DirectionPage> createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  GoogleMapController? mapController;

  final startLocation = const LatLng(37.5688983584163, 36.87825015925622);

  final finishLocation = const LatLng(37.04737977727039, 37.39000324637981);

  final Set<Polyline> polyline = <Polyline>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directions Page'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(target: startLocation, zoom: 9),
        polylines: polyline,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getDirections();
  }

  void _getDirections() async {
    const String mainApi = 'https://maps.googleapis.com/maps/api/directions/json?destination=';
    final String startPosition = "${startLocation.latitude},${startLocation.longitude}";
    final String endPosition = "${finishLocation.latitude},${finishLocation.longitude}";
    const String origin = '&origin=';

    const String key = '&key=AIzaSyAThj-XaVswHgzFCqSvCBjgZX9ALDYexHc';

    final Uri uri = Uri.parse(mainApi + startPosition + origin + endPosition + key);

    var response = await http.get(uri);

    Map data = json.decode(response.body);

    String encodedString = data['routes'][0]['overview_polyline']['points'];

    List<LatLng> points = _decodePoly(encodedString);

    setState(() {
      polyline.add(Polyline(polylineId: const PolylineId('route 1'), visible: true, points: points));
    });
    
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      points.add(point);
    }

    return points;
  }
}
