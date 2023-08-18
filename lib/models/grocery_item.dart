import 'package:project2/models/category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.question,
    required this.category,
  });

  final String id;
  final String question;
  final Category category;
}
