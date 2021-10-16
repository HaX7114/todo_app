import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/TaskContainerCubit/States.dart';
import 'package:todo_app/AppCubits/TaskContainerCubit/TaskContainerCubit.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/Models/Task.dart';
import 'package:todo_app/MyWidgets/MyText.dart';

class TaskContainer extends StatelessWidget {
  final title;
  final time;
  final endTime;
  final index;
  final taskStatus;
  var onTapDone;
  var onTapArchived;
  var onTapReminder;
  var onTapRepeat;
  String? reminderTime;
  Color firstColor;
  Color secondColor;

  TaskContainer(
      {Key? key,
      this.title,
      this.time,
      required this.taskStatus,
      required this.onTapDone,
      required this.onTapArchived,
      required this.onTapReminder,
      required this.onTapRepeat,
      this.endTime,
      this.reminderTime,//Default value
      this.firstColor = K_whiteColor,
      this.secondColor = K_whiteColor,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskContainerCubit(),
      child: BlocConsumer<TaskContainerCubit,TaskContainerStates>(
        listener: (context, state){

        },
        builder: (context, state){
          return GestureDetector(
            onLongPress: (){
              TaskContainerCubit.get(context).changeOnHold();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(K_radius),
                gradient: LinearGradient(
                  colors: [
                    index == 0 ? firstColor = K_aquaAccentColor : firstColor,
                    index == 0 ? secondColor = K_aquaColor : secondColor,
                  ],
                  stops: [0.1, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: shadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: '$title',
                      size: 17.0,
                      showEllipsis: true,
                      color: index == 0 ? K_whiteColor : K_blackColor,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Ionicons.time,
                          color: index == 0 ? K_whiteColor : K_pinkColor,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        MyText(
                          text: '$time',
                          size: 15.0,
                          fontWeight: FontWeight.w300,
                          color: index == 0 ? K_whiteColor : K_blackColor,
                        ), //First Time
                        SizedBox(
                          width: 5.0,
                        ),
                        MyText(
                          text: '-',
                          size: 15.0,
                          fontWeight: FontWeight.w300,
                          color: index == 0 ? K_whiteColor : K_blackColor,
                        ), //First Time
                        SizedBox(
                          width: 5.0,
                        ),
                        MyText(
                          text: '$endTime',
                          size: 15.0,
                          fontWeight: FontWeight.w300,
                          color: index == 0 ? K_whiteColor : K_blackColor,
                        ),
                      ],
                    ),
                    showReminder(taskStatus),
                    showIcons(TaskContainerCubit.get(context).onHold),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }

  showIcons(onHold){
    if(!onHold)
      return Container();
    else
      return SlideInDown(
        from: 20,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Mark as :',
                size: 15.0,
                fontWeight: FontWeight.w400,
                color: index == 0 ? K_whiteColor : K_blackAccentColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTapRepeat,
                    child: Icon(
                      Ionicons.repeat,
                      color: index == 0 ? K_whiteColor : K_pinkColor,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  GestureDetector(
                    onTap: onTapDone,
                    child: Icon(
                      Ionicons.checkmark_done_circle,
                      color: index == 0 ? K_whiteColor : Colors.greenAccent,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  GestureDetector(
                    onTap: onTapArchived,
                    child: Icon(
                      CupertinoIcons.archivebox_fill,
                      color: index == 0 ? K_whiteColor : K_orangeColor,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  GestureDetector(
                    onTap: onTapReminder,
                    child: Icon(
                      Ionicons.notifications,
                      color: index == 0 ? K_whiteColor : K_aquaColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  showReminder(taskStatus)
  {
    if(!isReminder(taskStatus))
      return Container();
    else
      return Padding(
        padding: const EdgeInsets.only(top: 10.0,),
        child: Row(
          children: [
            Icon(
                Ionicons.alarm,
                color: index == 0 ? K_whiteColor : K_aquaColor,
            ),
            SizedBox(
              width: 5.0,
            ),
            MyText(
              text: 'Daily, at ${reminderTime?? "00:00"}',
              size: 15.0,
              fontWeight: FontWeight.w400,
              color: index == 0 ? K_whiteColor : K_blackAccentColor,
            ),
          ],
        ),
      );
  }

  bool isReminder(taskStatus)
  {
    return taskStatus == K_reminderStatus ? true : false;
  }

}



