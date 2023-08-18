import 'package:project2/models/grocery_item.dart';
import 'package:project2/data/categories.dart';
import 'package:project2/models/category.dart';
 final groceryItems = [
  GroceryItem(
      id: 'a',
      question: 'Have you got your own Macbook for Development?',
      category: categories[Categories.important]!),
  GroceryItem(
      id: 'b',
      question: 'Have you ever worked on an IOS project?',
      category: categories[Categories.important]!),
  GroceryItem(
      id: 'c',
      question: 'Why you should be hired for this role?',
      category: categories[Categories.optional]!),
];