import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/util/dbhelper.dart';

class TodoList extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>TodoListState();


}

class TodoListState extends State {
  DBHelper dbHelper=new DBHelper();
  List<Todo> lists;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(lists == null){
      lists=List<Todo>();
      getdata();
    }
    return Scaffold(
      body: todolistitems(),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),

      ),
    );

  }
  ListView todolistitems(){
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context,int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(this.lists[position].id.toString()),
              ),
              title: Text(this.lists[position].title),
              subtitle: Text(this.lists[position].date),
              onTap: (){
                debugPrint(" Tapped on "+this.lists[position].id.toString());
              },
            ),


          );
        }
    );
  }

  void getdata(){
    final dbfuture=dbHelper.initdatabase();
    dbfuture.then((result){
      final todosfuture=dbHelper.getTodos();
      todosfuture.then((result){
        List<Todo> todolist=List<Todo>();
        count=result.length;
        for(int i=0;i<count;i++){
          todolist.add(Todo.fromObject(result[i]));
          debugPrint(todolist[i].title);

        }
        setState(() {
          lists=todolist;
          count=count;
        });
      });
    });
  }

}