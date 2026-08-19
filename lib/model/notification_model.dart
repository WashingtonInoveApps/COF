import 'package:flutter/material.dart';

class NotificationModel {
  final String description;
  final IconData? icon;

  NotificationModel({
    required this.description,
    this.icon = Icons.info,
  });
}
