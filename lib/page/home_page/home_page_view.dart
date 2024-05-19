import 'package:flutter/material.dart';
import 'package:google_maps_using/page/directions_screen/direction_page_view.dart';
import 'package:google_maps_using/page/maps_page/maps_page.dart';
import 'package:google_maps_using/page/markers_page/markers_page_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map sample'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(),
            child: const Text('Map Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MarkersPageView(),
                ),
              );
            },
            child: const Text('Markers Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DirectionPage(),
                ),
              );
            },
            child: const Text('Direction Screen'),
          ),
        ],
      ),
    );
  }
}
