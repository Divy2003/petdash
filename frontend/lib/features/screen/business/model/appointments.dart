import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String title;
  final DateTime dateTime;
  final String status;

  Appointment({
    required this.title,
    required this.dateTime,
    required this.status,
  });
}