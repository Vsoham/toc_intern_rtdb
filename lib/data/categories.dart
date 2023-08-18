import 'package:flutter/material.dart';

import 'package:project2/models/category.dart';

const categories = {
  Categories.important: Category(
    'Required',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.optional: Category(
    'Optional',
    Color.fromARGB(255, 0, 225, 255),
  ),
};