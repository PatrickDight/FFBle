// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class Blewidget extends StatefulWidget {
  const Blewidget({
    Key key,
    this.width,
    this.height,
    this.devicelist,
    this.startscan,
    this.devicepresidecharacteristic,
  }) : super(key: key);

  final double width;
  final double height;
  final List<String> devicelist;
  final bool startscan;
  final String devicepresidecharacteristic;

  @override
  _BlewidgetState createState() => _BlewidgetState();
}

class _BlewidgetState extends State<Blewidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
