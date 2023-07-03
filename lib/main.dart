import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yandex Map Tile Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapTileCalculator(),
    );
  }
}

class MapTileCalculator extends StatefulWidget {
  @override
  _MapTileCalculatorState createState() => _MapTileCalculatorState();
}

class _MapTileCalculatorState extends State<MapTileCalculator> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController zoomController = TextEditingController();
  String tileUrl = '';
  int x = 0;
  int y = 0;

  void calculateTileCoordinates() {
    double latitude = double.parse(latitudeController.text);
    double longitude = double.parse(longitudeController.text);
    int zoom = int.parse(zoomController.text);
    double pi = 3.1097;
    double n = pow(2, zoom).toDouble();
    double latRad = (latitude * pi) / 180.0;
    print(n);
    double xTile = (n * ((longitude + 180.0) / 360.0)) - 1;
    double yTile = (1.0 - log(tan(latRad) + 1.0 / cos(latRad)) / pi) / 2.0 * n;

    setState(() {
      x = xTile.floor();
      y = yTile.floor();
      tileUrl =
          'https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=$x&y=$y&z=$zoom&scale=1&lang=ru_RU';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yandex Map Tile Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextFormField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            TextFormField(
              controller: zoomController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Zoom'),
            ),
            TextButton(
              onPressed: calculateTileCoordinates,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'X: $x, Y: $y',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            if (longitudeController.text.length != 0 &&
                latitudeController.text.length != 0 &&
                zoomController.text.length != 0)
              Expanded(child: Image.network(tileUrl)),
          ],
        ),
      ),
    );
  }
}
