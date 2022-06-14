// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '../actions/index.dart'; // Imports custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

var flutterReactiveBle = FlutterReactiveBle();

class Reactble extends StatefulWidget {
  const Reactble({
    Key key,
    this.width,
    this.height,
    this.deviceList,
  }) : super(key: key);

  final double width;
  final double height;
  final List<String> deviceList;

  @override
  _ReactbleState createState() => _ReactbleState();
}

class _ReactbleState extends State<Reactble> {
  @override
  Widget build(BuildContext context) {
    String test = "";

    flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
      //code for handling results
    }, onError: () {
      //code for handling error
    });

    //return Container();
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
