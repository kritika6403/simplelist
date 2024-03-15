import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:simplelist/todoModel.dart';
class HttpService extends ChangeNotifier{
 var url = "https://jsonplaceholder.typicode.com/todos";
 List<TodoModel> todoList = [];
 bool isLoading = true;
 Future<List<TodoModel>> getTodoList() async{
   var response = await http.get(Uri.parse(url));
   if(response.statusCode == 200){
     var data = json.decode(response.body);
     todoList = data.map<TodoModel>((e)=>TodoModel.fromJson(e)).toList();
     isLoading = false;
     notifyListeners();
     return todoList;
   }
   else {
     isLoading = false;
     notifyListeners();
     return [];
   }
 }

}