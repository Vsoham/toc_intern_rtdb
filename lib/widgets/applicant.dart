import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project2/data/dummy_items.dart';
import 'package:http/http.dart' as http;
import 'package:project2/models/grocery_item.dart';
import 'package:project2/data/categories.dart';
class ApplicantScreen extends StatefulWidget {
  const ApplicantScreen({Key? key}) : super(key: key);

  @override
  State<ApplicantScreen> createState() => _ApplicantScreenState();
}

class _ApplicantScreenState extends State<ApplicantScreen> {
  List<GroceryItem> _questionItems=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadQuestion();
  }
  void _loadQuestion() async
  {
    final url=Uri.https('project4-bc9ac-default-rtdb.firebaseio.com','question-list.json');
    final response=await http.get(url);
    print(response.body);
    final Map<String,dynamic> listdata=json.decode(response.body);
    final List<GroceryItem> _loadedItems=[];
    for (final item in listdata.entries)
      {
        final category =categories.entries.firstWhere((catItem) => catItem.value.title==item.value['category']).value;
        _loadedItems.add(GroceryItem(id: item.key, question: item.value['question'], category: category));
      }
    setState(() {
      _questionItems=_loadedItems;

    });
  }
  Widget build(BuildContext context) {
    final _formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application'),
      ),
      body: Form(
        child: Column(
          children: [
            Text('Applying to XYZ limited'),
            Text('Resume'),
            Text('Cover Letter'),
            ListView.builder(
              scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _questionItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      // leading:  Text(_questionItems[index].id),
                      title: Text(_questionItems[index].question)
                  );
                }),
          ],
        ),
      )
    );

 
  }
}