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

class Ble extends StatefulWidget {
  const Ble({
    Key key,
    this.width,
    this.height,
    this.doScan,
  }) : super(key: key);

  final double width;
  final double height;
  final bool doScan;

  @override
  _BleState createState() => _BleState();
}

class _BleState extends State<Ble> {
  @override
  Widget build(BuildContext context) {
    String test = "A ";
    // Start scanning
    if (FFAppState().startscan) {
      test = test + " 1 ";
      flutterBlue.startScan(timeout: Duration(seconds: 10));
      test = test + " 2 ";
      // Listen to scan results
      var subscription = flutterBlue.scanResults.listen((results) {
        // do something with scan results
        test = test + " 3 ";
        for (ScanResult r in results) {
          test = test + " 4 ";
          FFAppState().devicelist.insert(0, "pat");
          FFAppState().devicelist.insert(0, r.device.name);
          //print('${r.device.name} found! rssi: ${r.rssi}');
        }
      });
      test = test + " 5 ";
    }
    ;

    return Text(
      "Counter: " +
          FFAppState().counter.toString() +
          "\n Scan: " +
          FFAppState().startscan.toString() +
          "\n Devices: " +
          FFAppState().devicelist.toString() +
          "\n Debug " +
          test,
      style: FlutterFlowTheme.of(context).bodyText1,
    );
  }
}
