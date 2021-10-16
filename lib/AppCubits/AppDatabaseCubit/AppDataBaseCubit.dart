import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/Models/Task.dart';
import 'package:todo_app/main.dart';

const K_tableTasks = 'TASKS';
const K_columnID = 'ID';
const K_columnTitle = 'TITLE';
const K_columnTime = 'TIME';
const K_columnEndTime = 'END_TIME';
const K_columnDate = 'DATE';
const K_columnStatus = 'STATUS';
const K_columnReminderTime = 'REMINDER_TIME';

class AppDatabaseCubit extends Cubit<AppDatabaseStates>
{
  AppDatabaseCubit() : super(InitialDatabaseState());

  List<Map> allTasks = [];

  List<Map> allArchivedTasks = [];

  List<Map> allDoneTasks = [];

  List<Map> allRemindedTasks = [];

  Database? myDatabase;

  String selectQuery = 'SELECT * FROM $K_tableTasks WHERE $K_columnStatus = "$K_newStatus"';
  String getArchived = 'SELECT * FROM $K_tableTasks WHERE $K_columnStatus = "$K_archivedStatus" ';
  String getDone = 'SELECT * FROM $K_tableTasks WHERE $K_columnStatus = "$K_doneStatus" ';
  String getReminded = 'SELECT * FROM $K_tableTasks WHERE $K_columnStatus = "$K_reminderStatus" ';


  //Channel between the UI and The bloc
  static AppDatabaseCubit get(context) => BlocProvider.of(context);

  Future executeInsert(String transaction,Database? database) async
  {
    print('inserting...');
    await database!.transaction((txn) async {
      await txn.rawInsert(transaction)
          .then((value) {
        print('Transaction insert executed Successfully');
        executeQuery(selectQuery,database);
        emit(InsertTaskState());
      })
          .catchError((error){
        print('Transaction failed to be executed cause of $error');
      });
    });
  }

  executeUpdateTable(int transactionNumber,int ID,Database? database,String? reminderTime) async
  {
    String? transaction;
    switch(transactionNumber)
    {
      case 0: transaction = 'UPDATE $K_tableTasks SET $K_columnStatus = "$K_newStatus" WHERE ID = $ID ';
        break;
      case 1: transaction = 'UPDATE $K_tableTasks SET $K_columnStatus = "$K_doneStatus" WHERE ID = $ID ';
        break;
      case 2: transaction = 'UPDATE $K_tableTasks SET $K_columnStatus = "$K_archivedStatus" WHERE ID = $ID ';
        break;
      case 3: transaction = 'UPDATE $K_tableTasks SET $K_columnStatus = "$K_reminderStatus" , $K_columnReminderTime = "$reminderTime"  WHERE ID = $ID ';
        break;

    }
    print('updating...');
    await database!.transaction((txn) async {
      await txn.rawUpdate(transaction!)
          .then((value) {
            print('Transaction updated executed Successfully');
            emit(UpdateTaskStatusState());
            //To update the screen data
            executeQuery(selectQuery, database);
            executeQueryOfDoneTasks(getDone, database);
            executeQueryOfArchivedTasks(getArchived, database);
            executeQueryOfRemindedTasks(getReminded, database);
          })
          .catchError((error){
        print('Transaction failed to be executed cause of $error');
      });
    });
  }

  Future<List<Map>> select() async {
    return await myDatabase!.rawQuery('Select * From $K_tableTasks');
  }

  Future executeQuery(String transaction,Database database) async
  {
    print('getting...');
     await database.rawQuery(transaction)
          .then((value) {
        print('Transaction query executed Successfully');
        allTasks = value;
        emit(GettingTasksState());
      })
          .catchError((error){
        print('Transaction failed to be executed cause of $error');
      });
  }

  Future executeQueryOfDoneTasks(String transaction,Database database) async
  {
    print('getting...');
    await database.rawQuery(transaction)
        .then((value) {
      print('Transaction query executed Successfully');
      allDoneTasks = value;
      emit(GettingTasksState());
    })
        .catchError((error){
      print('Transaction failed to be executed cause of $error');
    });
  }

  Future executeQueryOfArchivedTasks(String transaction,Database database) async
  {
    print('getting...');
    await database.rawQuery(transaction)
        .then((value) {
      print('Transaction query executed Successfully');
      allArchivedTasks = value;
      emit(GettingTasksState());
    })
        .catchError((error){
      print('Transaction failed to be executed cause of $error');
    });
  }

  Future executeQueryOfRemindedTasks(String transaction,Database database) async
  {
    print('getting...');
    await database.rawQuery(transaction)
        .then((value) {
      print('Transaction query executed Successfully');
      allRemindedTasks = value;
      emit(GettingTasksState());
    })
        .catchError((error){
      print('Transaction failed to be executed cause of $error');
    });
  }

  Future executeDelete(String transaction,Database? database) async
  {
    print('deleting...');
    await database!.transaction((txn) async {
      await txn.rawDelete(transaction)
          .then((value) {
            print('Transaction delete executed Successfully');
            //To make sure that the lists is empty
            allTasks = [];
            allRemindedTasks = [];
            allArchivedTasks = [];
            allDoneTasks = [];
            //***
            emit(DeleteTaskState());
            //To update the screen data
            executeQuery(selectQuery, database);
            executeQueryOfDoneTasks(getDone, database);
            executeQueryOfArchivedTasks(getArchived, database);
            executeQueryOfRemindedTasks(getReminded, database);
          })
          .catchError((error){
        print('Transaction failed to be executed cause of $error');
      });
    });
  }

  void connectDatabase() async
  {
     openDatabase(
        'MyTodoApp.db',
        version: 2,
        onCreate: (database, version) async{
          print('database created');
          await database.execute(
              'CREATE TABLE $K_tableTasks ('
                  '$K_columnID INTEGER PRIMARY KEY, '
                  '$K_columnTitle TEXT , '
                  '$K_columnTime TEXT , '
                  '$K_columnEndTime TEXT , '
                  '$K_columnDate TEXT , '
                  '$K_columnStatus TEXT)'
          ).then((value) => print('Table created')
          ).catchError((error){
            print('Error');
          });
        },
        onOpen: (db) async {
          print('Database Opened');
        },
       onUpgrade: _onUpgrade

    ).then((value){
       myDatabase = value;
       emit(InitialDatabaseState());

       executeQuery(selectQuery,value);//get tasks
       executeQueryOfDoneTasks(getDone, value);
       executeQueryOfArchivedTasks(getArchived, value);
       executeQueryOfRemindedTasks(getReminded, value);
     })
     .catchError((error){
       print('Database not opened cause of $error');
     });
  }

  // UPGRADE DATABASE TABLES
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database version is updated, alter the table
    await db.execute("ALTER TABLE $K_tableTasks ADD $K_columnReminderTime TEXT").then((value) => print('table altered'));
  }

}