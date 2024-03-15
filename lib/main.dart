import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplelist/httpService.dart';
import 'package:simplelist/pagination.dart';
import 'package:simplelist/todoModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>HttpService()),
        ChangeNotifierProvider(create: (_)=>Pagination()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Todo List'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
List<TodoModel> _list = [];
int currentPage = 1;
int itemPerPage = 50;
late Pagination pagination;
final ScrollController _scrollController = ScrollController();
@override
  void initState() {
    // TODO: implement initState
  getData();
    super.initState();


  }
  dispose(){
  _scrollController.dispose();
  super.dispose();
  }
  getData() async{
   HttpService httpService =  Provider.of(context,listen: false);
    pagination =  Provider.of(context,listen: false);
 await httpService.getTodoList();
_list =  pagination.loadMoreData( pagination.currentPagee,itemPerPage, httpService.todoList);
   _scrollController.addListener(() {_loadMoreData( httpService.todoList);});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Consumer2<HttpService,Pagination>(
        builder: (BuildContext context, HttpService value,pagination, Widget? child) {

          return value.isLoading? const Center(child: CircularProgressIndicator(),):
          value.todoList.isNotEmpty?ListView.builder(
            controller: _scrollController,
              itemCount: pagination.todoList.length + 1,
              itemBuilder: (context, index){

                if(index < pagination.todoList.length) {
                 return ListTile(
                   leading: Text(pagination.todoList[index].id.toString()),
                   title: Text(pagination.todoList[index].title!),
                 );
               }
               else if (pagination.todoList.length == value.todoList.length){
                 return Container();
               }
               else {
                 return const Center(child: CircularProgressIndicator());
               }
              }

                    ):Container();
        },

      )

    );
  }
  _loadMoreData(list){
  if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
  {

    _list = pagination.loadMoreData( pagination.currentPagee,itemPerPage, list );
  }
  }
}
