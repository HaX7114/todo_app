import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/MyTextField.dart';
import 'package:todo_app/Shared/ListViewOfTasks.dart';


class DoneScreen extends StatefulWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppDatabaseCubit()..connectDatabase(),
        child: BlocConsumer<AppDatabaseCubit, AppDatabaseStates>(
          listener: (context, state){

          },
          builder: (context, state){
            return FlipInX(
                child: ConditionalBuilder(
                  condition: AppDatabaseCubit.get(context).allDoneTasks.length > 0,
                  fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.checkmark_done,
                          color: K_blackAccentColor,
                          size: 50.0,
                        ),
                        K_vSpace,
                        MyText(text: 'No Done Tasks Yet', size: 20.0,color: K_pinkColor,),
                      ],
                    ),
                  ),
                  builder: (context) => SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ListViewOfTasks(isScrollableList: true,tasks: AppDatabaseCubit.get(context).allDoneTasks,appCubit: AppDatabaseCubit.get(context),)
                  ),
                )
            );
          },
        ),
    );
  }
}
