import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'LocationScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _time = '';
  String _location = 'Kuala Lumpur';
  String _url = 'http://worldtimeapi.org/api/timezone/Asia/Kuala_Lumpur';


  Future<void> _getTime() async {
  try {
    http.Response response = await http.get(Uri.parse(_url));
    Map data = jsonDecode(response.body);
    String datetime = data['datetime'];
    String utcOffset = data['utc_offset'];
    String offset = '';
    if (utcOffset.length >= 2) {
      offset = utcOffset.substring(1, 3);
    }
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));
    _time = DateFormat.jm().format(now);
  } catch (e) {
    _time = 'Error fetching time';
  }
  setState(() {});
}


  @override
  void initState() {
    super.initState();
    _getTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_location',
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '$_time',
              style: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
  onPressed: () async {
    dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _location = result['location'];
        _time = result['time'];
      });
    }
  },
  child: Text('Choose Location'),
),

          ],
        ),
      ),
    );
  }
}