import 'package:flutter/material.dart';

enum Categories {
  important,
  optional
}

class Category {
  const Category(this.title, this.color);

  final String title;
  final Color color;
}
