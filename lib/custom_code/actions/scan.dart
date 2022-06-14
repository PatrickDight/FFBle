// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

Future<List<String>> scan(
  int scanseconds,
  List<String> devicelist,
) async {
  // Add your function code here!
  devicelist.insert(0, 'testhere');
  FFAppState().devicelist.insert(0, 'too');

  // Start scanning
  flutterBlue.startScan(timeout: Duration(seconds: scanseconds));

  // Listen to scan results
  var subscription = flutterBlue.scanResults.listen((results) {
    // do something with scan results
    for (ScanResult r in results) {
      FFAppState().devicelist.insert(0, r.device.name);
      //print('${r.device.name} found! rssi: ${r.rssi}');
    }
  });

  // Stop scanning
  flutterBlue.stopScan();
  devicelist.insert(0, 'hello');

  return devicelist;
}
