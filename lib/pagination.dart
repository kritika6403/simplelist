import 'package:flutter/cupertino.dart';
import 'package:simplelist/todoModel.dart';

class Pagination extends ChangeNotifier{

List<TodoModel> todoList = [];
      int currentPagee = 1;
   loadMoreData(int currentPage,int itemsPerPage,dataList) {
    // Simulate loading data from an API or other source
Future.delayed(const Duration(seconds: 2),(){
  int nextIndex = (currentPage - 1) * itemsPerPage;
  for (int i = nextIndex; i < nextIndex + itemsPerPage; i++) {
    if (todoList.length < 200) {
      todoList.add(dataList[i]);
    }
  }
  currentPagee++;
  notifyListeners();

});


return todoList;

  }

}