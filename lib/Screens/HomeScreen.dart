import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/Models/NotificationAPI.dart';
import 'package:todo_app/MyWidgets/GradientContainer.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/TaskContainer.dart';
import 'package:todo_app/Screens/TodayTasks.dart';
import 'package:todo_app/Shared/BottomSheet.dart';
import 'package:todo_app/Shared/SnackBar.dart';

TextEditingController todoFieldController = TextEditingController();
class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = GlobalKey();



  List<Map> list = [];

  Widget build(BuildContext context) {
    var mainContext = context;//Used in snack bar

    return BlocProvider(
      create: (context) => AppDatabaseCubit()..connectDatabase(),
      child: BlocConsumer<AppDatabaseCubit, AppDatabaseStates>(
          listener: (context,states){

          },
          builder: (context, states){
            AppDatabaseCubit appCubit = AppDatabaseCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [K_pinkAccentColor,K_pinkColor],
                      stops: [0.1,0.9],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        color: K_pinkAccentColor,
                        blurRadius: 20.0,
                      )]
                ),
                child: FloatingActionButton(
                  child: Icon(Ionicons.add,size: 30.0,),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  onPressed: (){
                    scaffoldKey.currentState!.showBottomSheet(
                          (context) => bottomSheet(context,_formState,todoFieldController),
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0,left: 20.0,right: 20.0,top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async{
                                    list = await appCubit.select();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TodayTasks(list: list,useList: true,)
                                        )
                                    );
                                  },
                                  child: GradientContainer(
                                    icon: CupertinoIcons.square_arrow_right,
                                    title: 'On Going',
                                    height: 170.0,
                                    firstColor: K_pinkAccentColor,
                                    secondColor: K_pinkColor,
                                    numOfTasks: appCubit.allTasks.length,
                                  ),
                                ),
                                K_vSpace,
                                GradientContainer(
                                  icon: Ionicons.checkmark_done_outline,
                                  title: 'Done Tasks',
                                  height: 140.0,
                                  firstColor: K_blueAccentColor,
                                  secondColor: K_blueColor,
                                  numOfTasks: appCubit.allDoneTasks.length,
                                ),
                              ],
                            ),
                          ),
                          K_hSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientContainer(
                                  icon: CupertinoIcons.archivebox,
                                  title: 'Archived Tasks',
                                  height: 140.0,
                                  firstColor: K_orangeAccentColor,
                                  secondColor: K_orangeColor,
                                  numOfTasks: appCubit.allArchivedTasks.length,
                                ),
                                K_vSpace,
                                GradientContainer(
                                  icon: Ionicons.notifications_outline,
                                  title: 'Reminders',
                                  height: 170.0,
                                  firstColor: K_aquaAccentColor,
                                  secondColor: K_aquaColor,
                                  numOfTasks: appCubit.allRemindedTasks.length,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      K_vSpace,
                      //On going row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(text: 'On Going', size: 25.0,color: K_blackAccentColor,),
                          TextButton(
                            onPressed: () async {
                              list = await appCubit.select();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodayTasks(list: list,useList: true,)
                                  )
                              );
                            },
                            child: MyText(text: 'See all', size: 15.0,color: K_pinkAccentColor,fontWeight: FontWeight.w400,),
                          )
                        ],
                      ),
                      K_vSpace,
                      //On going container
                      FlipInY(
                          child: ConditionalBuilder(
                            condition: appCubit.allTasks.length > 0,
                            fallback: (context) => Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Center(child: Column(
                                children: [
                                  Icon(CupertinoIcons.doc_plaintext,color: K_blackAccentColor,size: 40.0,),
                                  K_vSpace,
                                  MyText(text: 'No Tasks Available', size: 15.0,color: K_pinkColor,),
                                ],
                              ),
                              ),
                            ),
                            builder: (context) => TaskContainer(
                              taskStatus: appCubit.allTasks[0][K_columnStatus],
                              onTapRepeat: () async {
                                //appCubit.executeUpdateTable(0, appCubit.allTasks[0][K_columnID], appCubit.myDatabase);
                                //Delete the notification if scheduled
                                await NotificationAPI.cancelNotification(appCubit.allTasks[0][K_columnID]);
                              },
                              onTapDone: () async {
                                appCubit.executeUpdateTable(1, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,null);
                                showSnackBar(
                                    context,
                                    'Task marked as done',
                                    K_whiteColor,
                                    icon: Ionicons.checkmark_done_circle,
                                    iconColor: Colors.greenAccent
                                );
                                //Delete the notification if scheduled
                                await NotificationAPI.cancelNotification(appCubit.allTasks[0][K_columnID]);
                              },
                              onTapArchived: () async {
                                appCubit.executeUpdateTable(2, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,null);
                                showSnackBar(
                                    context,
                                    'Task marked as archived',
                                    K_whiteColor,
                                    icon: CupertinoIcons.archivebox_fill,
                                    iconColor: K_orangeColor
                                );
                                //Delete the notification if scheduled
                                await NotificationAPI.cancelNotification(appCubit.allTasks[0][K_columnID]);
                              },
                              onTapReminder: (){
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
                                              appCubit.executeUpdateTable(3, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,'8:00 AM');
                                              Navigator.pop(context);//Remove the dialog
                                              showSnackBar(
                                                  mainContext,
                                                  'Task marked as reminder at 8:00 AM',
                                                  K_whiteColor,
                                                  icon: Ionicons.notifications,
                                                  iconColor: K_aquaColor
                                              );
                                              //Set notification
                                              await NotificationAPI.scheduleDailyWithTime(
                                                  NotificationAPI.repeatInMorning,
                                                  appCubit.allTasks[0][K_columnID],
                                                  'Good morning',
                                                  'From reminder : ' + appCubit.allTasks[0][K_columnTitle]
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
                                              appCubit.executeUpdateTable(3, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,'1:00 PM');
                                              Navigator.pop(context);//Remove the dialog
                                              showSnackBar(
                                                  mainContext,
                                                  'Task marked as reminder at 1:00 PM',
                                                  K_whiteColor,
                                                  icon: Ionicons.notifications,
                                                  iconColor: K_aquaColor
                                              );
                                              //Set notification
                                              await NotificationAPI.scheduleDailyWithTime(
                                                  NotificationAPI.repeatInAfternoon,
                                                  appCubit.allTasks[0][K_columnID],
                                                  'Good afternoon',
                                                  'From reminder : ' + appCubit.allTasks[0][K_columnTitle]
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
                                              appCubit.executeUpdateTable(3, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,'6:00 PM');
                                              Navigator.pop(context);//Remove the dialog
                                              showSnackBar(
                                                  mainContext,
                                                  'Task marked as reminder at 6:00 PM',
                                                  K_whiteColor,
                                                  icon: Ionicons.notifications,
                                                  iconColor: K_aquaColor
                                              );
                                              //Set notification
                                              await NotificationAPI.scheduleDailyWithTime(
                                                  NotificationAPI.repeatInEvening,
                                                  appCubit.allTasks[0][K_columnID],
                                                  'Good evening',
                                                  'From reminder : ' + appCubit.allTasks[0][K_columnTitle]
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
                                              appCubit.executeUpdateTable(3, appCubit.allTasks[0][K_columnID], appCubit.myDatabase,'8:00 PM');
                                              Navigator.pop(context);
                                              showSnackBar(
                                                  mainContext,
                                                  'Task marked as reminder at 8:00 PM',
                                                  K_whiteColor,
                                                  icon: Ionicons.notifications,
                                                  iconColor: K_aquaColor
                                              );
                                              //Set notification
                                              await NotificationAPI.scheduleDailyWithTime(
                                                  NotificationAPI.repeatInNight,
                                                  appCubit.allTasks[0][K_columnID],
                                                  'Good night',
                                                  'From reminder : ' + appCubit.allTasks[0][K_columnTitle]
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
                              title: appCubit.allTasks[0][K_columnTitle],
                              time: appCubit.allTasks[0][K_columnTime],
                              endTime: appCubit.allTasks[0][K_columnEndTime],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            );
          },

      ),
    );
  }
}
