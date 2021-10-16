

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/AppCubits/NavBarCubit/States.dart';

class NavBarCubit extends Cubit<NavBarStates>{

  NavBarCubit() : super(InitialNavState());

  //Channel between the UI and The bloc
  static NavBarCubit get(context) => BlocProvider.of(context);


  int mainIndex = 0;

  void changeMainIndex(value)
  {
    mainIndex = value;
    emit(ChangeNavState());
  }

}