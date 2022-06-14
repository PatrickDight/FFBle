import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';

String listToString(List<String> aliststring) {
  // Add your function code here!
  return aliststring.join(',');
}

int getcurrentint() {
  // Add your function code here!
  int val = 10;
  return val;
}

String convertLatLngToText(LatLng aLatLong) {
  // Add your function code here!
  return aLatLong.toString();
}
