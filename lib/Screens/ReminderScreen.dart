import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/Shared/ListViewOfTasks.dart';


class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
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
                condition: AppDatabaseCubit.get(context).allRemindedTasks.length > 0,
                fallback: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.notifications_outline,
                        color: K_blackAccentColor,
                        size: 50.0,
                      ),
                      K_vSpace,
                      MyText(text: 'No Reminders Yet', size: 20.0,color: K_pinkColor,),
                    ],
                  ),
                ),
                builder: (context) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListViewOfTasks(isScrollableList: true,tasks: AppDatabaseCubit.get(context).allRemindedTasks,appCubit: AppDatabaseCubit.get(context),)
                ),
              )
          );
        },
      ),
    );
  }
}
