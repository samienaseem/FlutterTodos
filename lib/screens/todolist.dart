import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/screens/TodoView.dart';
import 'package:todolist/util/dbhelper.dart';
import 'package:todolist/screens/todoDetails.dart';

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
        onPressed: (){
          navigatetodetails(new Todo(" "," ","3"));
        },
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),

      ),
    );

  }
  ListView todolistitems(){
    return ListView.builder(
        itemCount: count,
        itemBuilder: ( context, position){
          return Dismissible(
            key: Key(lists[position].title),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(
                right: 10.0
              ),
                child:Icon(
                Icons.delete,
              color: Colors.white,

            )),

          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
              /*setState(() {
                lists.removeAt(position);
              });*/
              onDismissed11(this.lists[position],position);
          },
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.lists[position].priority),
                child: Text(this.lists[position].priority.toString()),
              ),
              title: Text(this.lists[position].title),
              subtitle: Text(this.lists[position].date),
              onTap: (){
                debugPrint(" Tapped on "+position.toString());
                navigatetodetails(lists[position]);
              },

            ),


          ));
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

  getColor(String priority) {
    switch(priority){
      case "1":
        return Colors.red;
        break;

      case "2":
        return Colors.orange;
        break;

      case "3":
        return Colors.green;
        break;

      default:
        return Colors.green;
        break;

    }

  }

  void navigatetodetails(Todo todo) async {
    bool result= await Navigator.push(context,
    MaterialPageRoute(builder: (context)=>TodoDetails(todo)),
    );
    if (result==true){
      getdata();
    }

  }

  void onDismissed11(Todo direction,int pos) async {
    int res;
    if(lists.contains(direction)){
        res=await dbHelper.deleteTodo(direction.id);
        if(res!=0){
          setState(() {
            lists.remove(direction);
            count=lists.length;
          });
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: getColor(direction.priority) ,
            content: Text("Todo ${direction.title} has been Deleted "),
          ));
        }
    }

    /*debugPrint("${direction.id}, ${direction.title}");
    count=lists.length;
    bool a=lists.remove(direction);
    count=lists.length;
    if(a) {
      debugPrint("${a}");
      debugPrint("${lists.length}");
      debugPrint("${count}");
    }*/
      /*for(int i=0;i<pos;i++){
        debugPrint(lists[i].title);
      }*/


    /*setState(() {

    });*/
    /*int res;
    if(lists.contains(direction)){
            //lists.remove(direction);
     res= await dbHelper.deleteTodo(direction.id);
     setState(() {
       lists.removeAt(pos+1);
     });
      if(res!=0){

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Todo is deleted"),
        ));
      }


    }
    debugPrint(pos.toString());*/




    /*setState(() {
      lists.remove(direction);
    });*/


    }




    /*if(result!=0){
      AlertDialog alertDialog=AlertDialog(
        title: Text("Delete Todo"),
        content: Text("Todo has been deleted"),
      );
      showDialog(
          context: context,
        builder: (_)=>alertDialog
      );
    }*/
    /*if(lists.contains(direction)){
      setState(() {
        lists.remove(direction);
      });
    }*/


}