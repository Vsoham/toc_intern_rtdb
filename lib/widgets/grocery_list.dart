import 'package:flutter/material.dart';
import 'package:project2/data/categories.dart';
import 'package:project2/data/dummy_items.dart';
import 'package:project2/widgets/new_item.dart';
import 'package:project2/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class GroceryList extends StatefulWidget
{
  GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems=[];
  var _isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }
  void _loadItems() async
  {
    final url=Uri.https('project4-bc9ac-default-rtdb.firebaseio.com','question-list.json');
    final response=await http.get(url);
    if(response.body=='null')
      {
        setState(() {
          _isLoading=false;
        });
        return;
      }
    final Map<String,dynamic> listData=json.decode(response.body);
    final List<GroceryItem> _loadedItems=[];
    for (final item in listData.entries)
      {
        final category =categories.entries.firstWhere((catItem) => catItem.value.title==item.value['category']).value;
        _loadedItems.add(GroceryItem(id: item.key, question: item.value['question'], category: category));
      }
    setState(() {
      _groceryItems=_loadedItems;
      _isLoading=false;
    });
  }
  void _addItem() async
  {
    final newItem =await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx)=>NewItem()));
    _loadItems();
    if(newItem==null)
      return;
    _groceryItems.add(newItem);
  }
  bool isChecked=false;
  void _removeItem(GroceryItem item)
  {
    final url=Uri.https('project4-bc9ac-default-rtdb.firebaseio.com','question-list/${item.id}.json');
    // final response=await http.get(url);
    http.delete(url);
    setState(() {
      _groceryItems.remove(item);
    });
  }
  void _Saveitem()
  {
    final url=Uri.https('project4-bc9ac-default-rtdb.firebaseio.com','cover-letter.json');
    http.post(url,
    headers: {'Content-type':'application/json'},
    body: json.encode({
      'cover':isChecked,
    },
    ),
    );

  }
  @override
  Widget build(context){
    Widget content=Center(child: Text('No Questions Added yet'),);
    if(_isLoading)
      {
        content=const Center(child: CircularProgressIndicator(),);
      }
    if(_groceryItems.isNotEmpty)
      {
        setState(() {
          content=Expanded(
            child: ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index)=> Dismissible(
                onDismissed: (direction){
                  _removeItem(_groceryItems[index]);
                },
                key: ValueKey(_groceryItems[index].id),
                child: ListTile(
                  title: Text(_groceryItems[index].question),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItems[index].category.color,
                  ),
                ),
              ),
            ),
          );
        });
      }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Internship'),
        actions: [
          ElevatedButton(
              onPressed: _addItem,
              child: Text("Add Questions"),
          ),
        ],
      ),
      body: Form(
        child: Column(
          children: [
            Text('Add Cover Letter section?',
            style: TextStyle(
              fontSize: 20,
            ),),
            Checkbox(
                value: isChecked,
                onChanged:(bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                } ),
            content,
            ElevatedButton(onPressed: _Saveitem, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}


// Expanded(
// child: ListView.builder(
// itemCount: _groceryItems.length,
// itemBuilder: (ctx, index)=> ListTile(
// title: Text(_groceryItems[index].question),
// leading: Container(
// width: 24,
// height: 24,
// color: _groceryItems[index].category.color,
// ),
// ),
// ),
// ),