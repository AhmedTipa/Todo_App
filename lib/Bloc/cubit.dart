import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoo_app/Bloc/states.dart';
import 'package:todoo_app/Todo_App/screens/archived.dart';
import 'package:todoo_app/Todo_App/screens/done.dart';
import 'package:todoo_app/Todo_App/screens/tasks.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(InitTodoStates());

  static TodoCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    const Tasks(),
    const Done(),
    const Archived(),
  ];
  int currentIndex = 0;

  void changeBtmNavbar(index) {
    currentIndex = index;
    emit(TodoChangeBtmNavBarState());
  }

  late Database database;

  void createDataBase() {
    openDatabase('Todo.db', version: 1, onCreate: (database, version) {
      print('Database Created');
      database
          .execute(
          'create table tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('Table Created');
      }).catchError((error) {
        print('error $error');
      });
    }, onOpen: (database) {
      print('Database Opened');
      getDataBase(database);
    }).then((value) {
      database = value;
      emit(TodoCreateDataBaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData icon = Icons.add;

  void changeFabSheet({
    required bool isShow,
    required IconData fabIcon,
  }) {
    isBottomSheetShown = isShow;
    icon = fabIcon;
    emit(TodoChangeFabSheetState());
  }

  Future insertDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
          'insert into tasks (title,time,date,status)VALUES("$title","$time","$date","new")')
          .then((value) {
        emit(TodoInsertDataBaseState());
        getDataBase(database);
        print('$value Insert Successfully');
      }).catchError((error) {
        print('error $error');
      });
    });
  }

  List<Map> taskss = [];
  List<Map> done = [];
  List<Map> archived = [];

  void getDataBase(database) async {
    taskss = [];
    done = [];
    archived = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          taskss.add(element);
        } else if (element['status'] == 'done') {
          done.add(element);
        } else {
          archived.add(element);
        }
      });
      emit(TodoGetDataBaseState());
    });
  }

  void updateDataBase({
    required String status,
    required int id,

  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id= ?', //هي بتكتب كده مفيش علامات ,
        ['$status', id]
    ).then((value) {
      getDataBase(database);
      emit(TodoUpdateDataBaseState());
    });
  }

  void deleteDataBase

      ({
    required int id,

  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id], //هي بتكتب كده مفيش علامات ,

    )
        .
    then
      ((value) {
      getDataBase(database);
      emit(TodoUpdateDataBaseState());
    });
  }
}
