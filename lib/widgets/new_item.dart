import 'package:flutter/material.dart';
import 'package:project2/data/categories.dart';
import 'package:project2/models/category.dart';
import 'package:project2/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class NewItem extends StatefulWidget
{
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}
class _NewItemState extends State<NewItem>
{
  final _formKey=GlobalKey<FormState>();
  var _enteredQues='';
  var _selectedCategory=categories[Categories.important]!;
  var _isSending=false;
  void _saveItem() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending=true;
      });
      final url=Uri.https('project4-bc9ac-default-rtdb.firebaseio.com','question-list.json');
     final response=await http.post(url,
      headers: {'Content-Type':'application/json',
      },
        body: json.encode({
          'question': _enteredQues,
          'category':_selectedCategory.title
        },),
      );
     final Map<String,dynamic> resData=json.decode(response.body);
     if(!context.mounted)
       return;
     Navigator.of(context).pop(GroceryItem(id: resData['name'], question: _enteredQues, category: _selectedCategory));
      // Navigator.of(context).pop(GroceryItem(
      //     id: DateTime.now().toString(),
      //     question: _enteredQues,
      //     category: _selectedCategory
      // ),
      // );
    }
  }
  @override
  Widget build(context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Enter Question'),
                ),
                validator: (value){
                  if(value==null || value.isEmpty || value.trim().length<=1)
                  return 'Question must be between 1 and 50 characters';
                  return null;
                },
                onSaved: (value){
                  _enteredQues=value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                        items: [
                          for(final  category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 12,),
                                  Text(category.value.title),

                                ],
                              ),
                          )
                        ],
                        onChanged: (value){
                          setState(() {
                            _selectedCategory=value!;
                          });
                        }
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed:(_isSending)?null: () {
                    _formKey.currentState!.reset();
                  }, child: const Text('Reset')),
                  ElevatedButton(onPressed:_isSending?null: _saveItem, child:_isSending?SizedBox(width: 16,height: 16,child: CircularProgressIndicator(),) :Text('Submit'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}