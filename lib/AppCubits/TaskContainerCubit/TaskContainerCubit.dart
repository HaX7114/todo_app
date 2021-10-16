

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/AppCubits/TaskContainerCubit/States.dart';

class TaskContainerCubit extends Cubit<TaskContainerStates>{

  TaskContainerCubit() : super(InitialTaskState());

  //Channel between the UI and The bloc
  static TaskContainerCubit get(context) => BlocProvider.of(context);


  bool onHold = false;

  void changeOnHold()
  {
    onHold = true;
    emit(ChangeTaskState());
  }

}