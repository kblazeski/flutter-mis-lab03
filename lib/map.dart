import 'package:flutter/material.dart';
import 'package:flutter_lab03/model/exam.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  final List<Exam> exams;
  const Map({Key? key, required this.exams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: exams.length > 0
            ? LatLng(exams[0].location.latitude, exams[0].location.longitude)
            : LatLng(41, 27),
        zoom: 10.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return Text("© OpenStreetMap contributors");
          },
        ),
        MarkerLayerOptions(
          markers: [
            ...exams.map((exam) {
              return Marker(
                width: 60.0,
                height: 60.0,
                point: LatLng(exam.location.latitude, exam.location.longitude),
                builder: (ctx) => Container(
                  child: FlutterLogo(),
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}
