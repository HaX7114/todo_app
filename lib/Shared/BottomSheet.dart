
//Shared in Notification page, TodayTasks

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/Models/Task.dart';
import 'package:todo_app/MyWidgets/MyButton.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/MyTextField.dart';
import 'package:todo_app/Screens/NavigationPage.dart';
import 'package:todo_app/Shared/SnackBar.dart';
import 'package:todo_app/main.dart';



bottomSheet(context,GlobalKey<FormState> _formState,TextEditingController todoFieldController) {

  TimeOfDay? startTime;//Saves the value of start time to use automatically in end time if the user does not choose end time
  Task task = Task();
  var hours = TimeOfDay.now().hour + 1;
  task.date =  DateFormat.yMd().format(DateTime.now());//as a default value
  task.time =  TimeOfDay.now().format(context);//as a default value
  task.endTime =  TimeOfDay.now().replacing(hour: hours < TimeOfDay.hoursPerDay ? hours : (hours - hours)).format(context);//as a default value end time will be more than starting by 1 hour
  task.status = K_newStatus;

  return Container(
    height: NavigationPage.heightOfDevice * 0.5,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(K_radius),
          topLeft: Radius.circular(K_radius)
      ),
      color: K_whiteColor,
    ),
    child: Form(
      key: _formState,
      child: FlipInX(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0,left: 20.0,right: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                MyTextField(
                  textController: todoFieldController,
                  labelText: 'Type a todo here',
                  borderColor: K_pinkColor,
                  validatorText: 'Please type a todo task !',
                  prifixIcon: CupertinoIcons.pencil_outline,
                ),
                K_vSpace,
                MyButton(
                  fillColor: K_backgroundColor,
                  text: 'Pick a date',
                  textColor: K_pinkColor,
                  onPressed: (){
                    var date = DateTime.now();
                    showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: date,
                        lastDate: date.add(Duration(days: 7))
                    ).then((value) => task.date = DateFormat.yMd().format(value!));
                  },
                ),
                K_vSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyButton(
                        text: 'Starting time',
                        onPressed: (){
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            task.time = value!.format(context);
                            startTime = value.replacing(hour: value.hour + 1);
                            task.endTime = value.replacing(hour: value.hour + 1).format(context);
                          });
                        },
                        fillColor: K_backgroundColor,
                        textColor: K_pinkColor,

                      ),
                    ),
                    K_hSpace,
                    Expanded(
                      child: MyButton(
                        text: 'Ending time',
                        textColor: K_pinkColor,
                        onPressed: (){
                          showTimePicker(
                            context: context,
                            initialTime: startTime?? TimeOfDay.now(),
                          ).then((value) => task.endTime = value!.format(context)
                          );
                        },
                        fillColor: K_backgroundColor,
                      ),
                    ),
                  ],
                ),
                K_vSpace,
                MyButton(
                  text: 'Add task',
                  onPressed: (){
                    if(_formState.currentState!.validate())
                      {
                        String query = 'INSERT INTO $K_tableTasks ('
                            '$K_columnTitle,'
                            '$K_columnTime,'
                            '$K_columnEndTime,'
                            '$K_columnDate,'
                            '$K_columnStatus) VALUES("${todoFieldController.text}", "${task.time}", "${task.endTime}", "${task.date}", "${task.status}")';

                        AppDatabaseCubit.get(context).executeInsert(query,AppDatabaseCubit.get(context).myDatabase);
                        Navigator.pop(context);
                        showSnackBar(
                            context,
                            'Task added',
                            K_pinkColor,
                            icon: Ionicons.add_circle,
                            iconColor: K_whiteColor
                        );
                      }
                  },
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        ),
      ),
    ),
  );
}

