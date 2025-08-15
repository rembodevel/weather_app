import 'package:flutter/material.dart';

class CityMaps extends StatefulWidget {
  const CityMaps({super.key, required this.city});
  final String city;

  @override
  State<CityMaps> createState() => _CityMapsState();
}

class _CityMapsState extends State<CityMaps> {
  @override
  Widget build(BuildContext context) {
    print('Вторая запись ${widget.city}');
    return Scaffold(
      appBar: AppBar(title: Text(widget.city)),
      body: Center(
        child: Image.asset('assets/image/cityMaps.png'),
      ),
    );
  }
}
