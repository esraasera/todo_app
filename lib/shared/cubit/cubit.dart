import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/modules/new_tasks/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super (AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  bool isButtomSheetShown = false;
  IconData navBarIcon = Icons.add;

  List<String>titles=[
    'New Tasks',
    'done Tasks',
    'archived Tasks',

  ];

  List<Widget>screens=[
     NewTasks(),
     DoneTasks(),
    ArchiveTasks(),
  ];

   List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];


  void changeBottomNavBar(int index){

    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  void changeButtomSheetShown({
    required IconData icon,
    required bool isShown,
}){
    isButtomSheetShown = isShown ;
    navBarIcon = icon;
    emit(AppChangeBottomSheetShownState());

  }

  void createDatabase(){
    openDatabase(
        'Todo.db',
        version: 1,
      onCreate:(database,version)async{
        print('database created');
        await database.execute(
           'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT) ',
       ).then((value){
         print('table created');
       });
      },
      onOpen:(database){
        getDataFromDatabase(database);
        print('database opened');
      }
    ).then((value) {
      database = value ;
      emit(AppCreateDatabaseState());
    });
  }

    insertToDatabase({
     required String title,
     required String time,
     required String date,
   })async{
   await database.transaction((txn) {
  return txn .rawInsert(
   'INSERT INTO tasks (title,time,date,status)VALUES("$title","$time","$date","new")'
  ).then((value) {
    print('$value inserted successfully');
    emit(AppInsertDatabaseState());
    getDataFromDatabase(database);
  }).catchError((error){
    print('ERROR WHILE INSERTING NEW RECORD ${error.toString()}');
  });
});
  }

 void getDataFromDatabase(database)async{
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseLoadingState());
      await database.rawQuery('SELECT * FROM tasks').then((value){
        value.forEach((e){
          if(e['status'] == 'new')
            newTasks.add(e);
          else if(e['status']=='done')
            doneTasks.add(e);
          else
            archivedTasks.add(e);
        });
        emit(AppGetDatabaseState());

      });

}

void updateData ({
    required String status,
    required int id,
}){
 database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ',['$status',id]).then((value) {
   getDataFromDatabase(database);
   emit(AppUpdateDatabaseState());
});

}

  void deleteData({
    required int id,
})async{

    await database.rawDelete('DELETE FROM tasks WHERE id =?',[id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });

  }
}