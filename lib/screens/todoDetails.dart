
import 'package:flutter/material.dart';
import 'package:todolist/util/dbhelper.dart';
import 'package:todolist/model/todo.dart';
import 'package:intl/intl.dart';
import 'dart:async';

final List<String> choices=const <String>[
  "Save Todo & Back",
  "Delete Todo",
  "Back to List"
];
DBHelper helper=DBHelper();

const menusave="Save Todo & Back";
const menudelete="Delete Todo";
const menuback="Back to List";

class TodoDetails extends StatefulWidget{
  final Todo todo;
  TodoDetails(this.todo);

  @override
  State<StatefulWidget> createState()=>TodoDetailsStates(todo);

}

class TodoDetailsStates extends State{
  Todo todo;
  TodoDetailsStates(Todo todo){
    this.todo=todo;
  }

  final _priorities = [ 'High' , 'Medium' , 'Low' ];
  String _priority='Low';
  TextEditingController titleController=TextEditingController();
  TextEditingController DescController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text=todo.title;
    DescController.text=todo.description;
    TextStyle textStyle=Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
             itemBuilder: (BuildContext context){
               return choices.map((String value){
                 return PopupMenuItem<String>(
                   value: value,
                   child: Text(value),
                 );
               }).toList();
             },
          )
        ],
      ),
      body: ListView(children: <Widget>[Padding(
          padding: EdgeInsets.only(
            top: 30.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
                bottom: 10.0
            ),
              child:TextField(

            controller: titleController,
            style: textStyle,
                onChanged: (value)=>this.UpdateTitle(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Title",
              labelStyle: textStyle
            ),
          )),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0
            ),
              child:TextField(

                onChanged: (value)=>this.updatedesc(value),
            controller: DescController,
            style: textStyle,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: "Description",
                labelStyle: textStyle
            ),
          )
          ),
           ListTile(title:DropdownButton<String>(

             icon:Icon(Icons.list),
             underline: Container(
               height: 1,
               color: Colors.red,
             ),
             value: retrievePrior(todo.priority),
            items: _priorities.map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            style: textStyle,
            onChanged: (String value){
               Updatepriority(value);
            },
          ))
        ],
      ))]),
    );
  }


  void select(String value)async {
    int result;
    switch(value){
      case menusave:
        save();
        break;
      case menudelete:
        Navigator.pop(context,true);
        if(todo.id==null){
          return;
        }
        result= await helper.deleteTodo(todo.id);
        if(result!=0){
          AlertDialog alertDialog=AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
          );
          showDialog(
              context: context,
            builder: (_)=>alertDialog,
          );
        }
        break;
      case menuback:
        Navigator.pop(context,true);
        break;

      default:

    }

  }

  void save() {
    todo.date=new DateFormat.yMd().format(DateTime.now());
    if(todo.id!=null){
      helper.updateTodo(todo);
    }
    else{
      /*UpdateTitle;
      updatedesc();*/
      helper.inserttodp(todo);
    }

    Navigator.pop(context,true);

  }
  void Updatepriority(String value){
    switch(value){
      case "High":
        todo.priority="1";
        break;
      case "Medium":
        todo.priority="2";
        break;
      case "Low":
        todo.priority="3";
        break;

      default:
    }
    setState(() {
      _priority=value;
    });

  }

  void UpdateTitle(value){
    //setState(() {
      todo.title=value;
    //});
  }
  void updatedesc(value){
    //setState(() {
      todo.description=DescController.text;
    //});
  }

  String retrievePrior(String priority) {
   if(priority=="3"){
     return "Low";
   }


   }

}
