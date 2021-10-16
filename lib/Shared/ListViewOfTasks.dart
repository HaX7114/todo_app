import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/Models/NotificationAPI.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/TaskContainer.dart';
import 'package:todo_app/Screens/NavigationPage.dart';
import 'package:todo_app/Shared/SnackBar.dart';
import 'package:todo_app/main.dart';


class ListViewOfTasks extends StatelessWidget {
  final List<Map> tasks;
  final appCubit;
  bool isScrollableList;//Controls the scroll of the list

  ListViewOfTasks({Key? key,required this.tasks, this.appCubit,this.isScrollableList = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainContext = context;//Used in snack bar
    return ListView.builder(
        shrinkWrap: true,
        physics: !isScrollableList ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
        itemBuilder: (context,index){
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: MyText(
                      size: 15.0,
                      text: 'Delete task',
                      color: K_whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (DismissDirection direction) async{
              appCubit.executeDelete('DELETE FROM $K_tableTasks WHERE $K_columnID = ${tasks[index][K_columnID]}',appCubit.myDatabase);
              showSnackBar(
                  context,
                  'Task deleted',
                  K_whiteColor,
                  icon: CupertinoIcons.delete,
                  iconColor: Colors.redAccent
              );
              await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: '${tasks[index][K_columnTime]}',
                        size: 15.0,
                        color: K_greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      K_hSpace,
                      Expanded(
                        child: TaskContainer(
                          reminderTime: tasks[index][K_columnReminderTime],
                          taskStatus: tasks[index][K_columnStatus],
                          onTapRepeat: () async {
                            appCubit.executeUpdateTable(0, tasks[index][K_columnID], appCubit.myDatabase,null);
                            showSnackBar(
                                context,
                                'Task added to On Going',
                                K_whiteColor,
                                icon: CupertinoIcons.square_arrow_right,
                                iconColor: K_pinkColor
                            );
                            //Delete the notification if scheduled
                            await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                          },
                          onTapDone: () async {
                            appCubit.executeUpdateTable(1, tasks[index][K_columnID], appCubit.myDatabase,null);
                            showSnackBar(
                                context,
                                'Task marked as done',
                                K_whiteColor,
                                icon: Ionicons.checkmark_done_circle,
                                iconColor: Colors.greenAccent
                            );
                            //Delete the notification if scheduled
                            await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                          },
                          onTapArchived: () async {
                            appCubit.executeUpdateTable(2, tasks[index][K_columnID], appCubit.myDatabase,null);
                            showSnackBar(
                                context,
                                'Task marked as archived',
                                K_whiteColor,
                                icon: CupertinoIcons.archivebox_fill,
                                iconColor: K_orangeColor
                            );
                            //Delete the notification if scheduled
                            await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                          },
                          onTapReminder: () async {
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.clock,
                                      color: K_pinkColor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    MyText(text: 'Set a daily reminder', size: 18.0,color: K_blackAccentColor,),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            appCubit.executeUpdateTable(3, tasks[index][K_columnID], appCubit.myDatabase,'8:00 AM');
                                            Navigator.pop(context);//Remove the dialog
                                            showSnackBar(
                                                mainContext,
                                                'Task marked as reminder at 8:00 AM',
                                                K_whiteColor,
                                                icon: Ionicons.notifications,
                                                iconColor: K_aquaColor
                                            );
                                            //Delete last notification
                                            await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                                            //Set notification
                                            await NotificationAPI.scheduleDailyWithTime(
                                                NotificationAPI.repeatInMorning,
                                                tasks[index][K_columnID],
                                                'Good morning',
                                                'From reminder : ' + tasks[index][K_columnTitle]
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            MyText(text: 'Morning', size: 15.0,fontWeight: FontWeight.w600,color: K_blackAccentColor,),
                                            MyText(text: '8:00 AM', size: 15.0,fontWeight: FontWeight.w400,color: K_blackAccentColor,),
                                          ],),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          appCubit.executeUpdateTable(3, tasks[index][K_columnID], appCubit.myDatabase,'1:00 PM');
                                          Navigator.pop(context);//Remove the dialog
                                          showSnackBar(
                                              mainContext,
                                              'Task marked as reminder at 1:00 PM',
                                              K_whiteColor,
                                              icon: Ionicons.notifications,
                                              iconColor: K_aquaColor
                                          );
                                          //Delete last notification
                                          await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                                          //Set notification
                                          await NotificationAPI.scheduleDailyWithTime(
                                              NotificationAPI.repeatInAfternoon,
                                              tasks[index][K_columnID],
                                              'Good afternoon',
                                              'From reminder : ' + tasks[index][K_columnTitle]
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(text: 'Afternoon', size: 15.0,fontWeight: FontWeight.w600,color: K_blackAccentColor,),
                                            MyText(text: '1:00 PM', size: 15.0,fontWeight: FontWeight.w400,color: K_blackAccentColor,),
                                          ],),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          appCubit.executeUpdateTable(3, tasks[index][K_columnID], appCubit.myDatabase,'6:00 PM');
                                          Navigator.pop(context);//Remove the dialog
                                          showSnackBar(
                                              mainContext,
                                              'Task marked as reminder at 6:00 PM',
                                              K_whiteColor,
                                              icon: Ionicons.notifications,
                                              iconColor: K_aquaColor
                                          );
                                          //Delete last notification
                                          await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                                          //Set notification
                                          await NotificationAPI.scheduleDailyWithTime(
                                              NotificationAPI.repeatInEvening,
                                              tasks[index][K_columnID],
                                              'Good evening',
                                              'From reminder : ' + tasks[index][K_columnTitle]
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(text: 'Evening', size: 15.0,fontWeight: FontWeight.w600,color: K_blackAccentColor,),
                                            MyText(text: '6:00 PM', size: 15.0,fontWeight: FontWeight.w400,color: K_blackAccentColor,),
                                          ],),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                          appCubit.executeUpdateTable(3, tasks[index][K_columnID], appCubit.myDatabase,'8:00 PM');
                                          Navigator.pop(context);
                                          showSnackBar(
                                              mainContext,
                                              'Task marked as reminder at 8:00 PM',
                                              K_whiteColor,
                                              icon: Ionicons.notifications,
                                              iconColor: K_aquaColor
                                          );
                                          //Delete last notification
                                          await NotificationAPI.cancelNotification(tasks[index][K_columnID]);
                                          //Set notification
                                          await NotificationAPI.scheduleDailyWithTime(
                                              NotificationAPI.repeatInNight,
                                              tasks[index][K_columnID],
                                              'Good night',
                                              'From reminder : ' + tasks[index][K_columnTitle]
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(text: 'Night', size: 15.0,fontWeight: FontWeight.w600,color: K_blackAccentColor,),
                                            MyText(text: '8:00 PM', size: 15.0,fontWeight: FontWeight.w400,color: K_blackAccentColor,),
                                          ],),
                                      ),
                                    ],
                                  ),
                                ),

                              );
                            });
                          },
                          index: index,
                          time: tasks[index][K_columnTime],
                          title: tasks[index][K_columnTitle],
                          endTime: tasks[index][K_columnEndTime],
                        ),
                      ),
                    ],
                  ),
                  K_vSpace,
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    color: K_greyColor,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: tasks.length
    );
  }


}
