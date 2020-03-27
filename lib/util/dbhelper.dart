import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/model/todo.dart';

class DBHelper{
  static final DBHelper _dbHelper=DBHelper._internal();

  String tbltodo="todo";
  String colId="id";
  String colTitle="title";
  String colDesc="description";
  String colPriority="priority";
  String colDate="date";


  DBHelper._internal();

  factory DBHelper(){
    return _dbHelper;
  }
  static Database _db;

  Future<Database> get db async{

    if(_db==null){
      _db=await initdatabase();
    }
    return _db;

  }

  Future<Database> initdatabase() async{
    Directory dir=await getApplicationDocumentsDirectory();
    String path=dir.path + "todo.db";
    var todos=await openDatabase(path,version: 1,onCreate: _oncreateDb);
    return todos;

  }
  void _oncreateDb(Database db,int newVersion) async{
    await db.execute("CREATE TABLE $tbltodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDesc TEXT, $colPriority TEXT,"
        +" $colDate TEXT)");

  }

  Future<int> inserttodp(Todo todo)async{
    Database db=await this.db;
    var result= await db.insert(tbltodo, todo.tomap());
    return result;

  }
  Future<List> getTodos() async{
    Database db=await this.db;
    var result=await db.rawQuery("SELECT * FROM $tbltodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount()async{
    Database db=await this.db;
    var result=Sqflite.firstIntValue(
    await db.rawQuery("select count (*) from $tbltodo")
    );
    return result;
  }

  Future<int> updateTodo(Todo todo)async{
    Database db=await this.db;
    var result=await db.update(tbltodo, todo.tomap(),
    where: "$colId=?",
    whereArgs: [todo.id]);

    return result;

  }

  Future<int> deleteTodo(int id) async{
    Database db=await this.db;
    var result=await db.rawDelete('Delete from $tbltodo where $colId=$id');
    return result;
  }



}