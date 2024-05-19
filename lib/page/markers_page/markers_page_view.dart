// ignore_for_file: depend_on_referenced_packages

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersPageView extends StatefulWidget {
  const MarkersPageView({super.key});

  @override
  State<MarkersPageView> createState() => _MarkersPageViewState();
}

class _MarkersPageViewState extends State<MarkersPageView> {
  final _kahCamii = const CameraPosition(target: LatLng(37.5889794, 36.9024665), zoom: 15);

  static const _kahnfkHas = LatLng(37.59437803146297, 36.92344200943422);

  static const _kahOtoDoseme = LatLng(37.56103637018731, 36.95693684379353);

  static const _kahAVM = LatLng(37.570605360025695, 36.922672920656616);

  BitmapDescriptor autoDosemeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor avmIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _getCustomMarker();
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _getCustomMarker() async {
    final Uint8List autoDosemeMarkerIcon = await getBytesFromAssets('assets/image/auto.png', 100);
    autoDosemeIcon = BitmapDescriptor.fromBytes(autoDosemeMarkerIcon);

    final Uint8List avmMarkerIcon = await getBytesFromAssets('assets/image/shopping-cart.png', 100);
    avmIcon = BitmapDescriptor.fromBytes(avmMarkerIcon);

    setState(() {});
  }

  final markerNFK = const Marker(
    markerId: MarkerId('NFK Sehir hastanesi'),
    position: _kahnfkHas,
    infoWindow: InfoWindow(title: 'Kahramanmaras hastanesi'),
  );

  @override
  Widget build(BuildContext context) {
    final auto = createMarker('auto', _kahOtoDoseme, autoDosemeIcon, 'Arabayi Duzelttir');
    final avm = createMarker('avm', _kahAVM, avmIcon, 'Avm den esya al');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers Sample'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _kahCamii,
        markers: {
          markerNFK,
          auto,
          avm,
        },
      ),
    );
  }

  Marker createMarker(String id, LatLng pos, BitmapDescriptor icon, String title) {
    return Marker(
      markerId: MarkerId(id),
      position: pos,
      icon: icon,
      infoWindow: InfoWindow(title: title),
    );
  }
}
