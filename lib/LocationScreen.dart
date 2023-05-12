import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<String> locations = [    'Kuala Lumpur',    'Seoul',    'Tokyo',  ];

  void updateTime(index) async {
    String location = locations[index];
    String url = 'http://worldtimeapi.org/api/timezone/${location.replaceAll(' ', '_')}';
    try {
      http.Response response = await http.get(Uri.parse(url));
      Map data = jsonDecode(response.body);
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      print('Popping Navigator with context: $context');
      Navigator.pop(context, {
        'location': location,
        'time': DateFormat.jm().format(now),
      });
    } catch (e) {
      print('Error fetching time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              updateTime(index);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 4.0,
                ),
                child: ListTile(
                  title: Text(
                    locations[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
