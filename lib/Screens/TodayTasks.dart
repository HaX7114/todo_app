
import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/Models/Task.dart';
import 'package:todo_app/MyWidgets/DayContainer.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/TaskContainer.dart';
import 'package:todo_app/Shared/BottomSheet.dart';
import 'package:todo_app/Shared/ListViewOfTasks.dart';

const double upperSidePadding = 20.0;

class TodayTasks extends StatelessWidget {

  final List<Map> list;
  bool useList; //Used to use the the list that navigated from the prev page

  TodayTasks({Key? key,required this.list,this.useList = false}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController todoFieldController = TextEditingController();
  final dateOfDay = DateFormat.MMMMd().format(DateTime.now());
  final todayDate = DateTime.now();
  final weekDay = DateTime.now().weekday;
  final days = [
    'Mon',//1
    'Tue',//2
    'Wed',//3
    'Thu',//4
    'Fri',//5
    'Sat',//6
    'Sun',//7
  ];

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AppDatabaseCubit()..connectDatabase(),
      child: BlocConsumer<AppDatabaseCubit , AppDatabaseStates>(
        listener: (context , state){

        },
        builder: (context , state){
          AppDatabaseCubit dbCubit = AppDatabaseCubit.get(context);
          if(useList)
            {
              dbCubit.allTasks = list;
              useList = false;
            }
          return Scaffold(
            key: scaffoldKey,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
              child: ElasticInDown(
                child: Container(
                  width: double.infinity,
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
                    isExtended: true,
                    child: MyText(text: 'Add New Task', size: 15.0,color: K_whiteColor,),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    onPressed: (){
                      scaffoldKey.currentState!.showBottomSheet(
                            (context) => bottomSheet(context,_formState,todoFieldController),
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              toolbarHeight: 70.0,
              centerTitle: true,
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.chevron_back,
                  size: 25.0,
                  color: K_blackColor,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyText(text: 'Today\'s Tasks', size: 18.0, color: K_blackColor),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: K_backgroundColor,
            body: FlipInX(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //The upper side of the column
                    Padding(
                      padding: const EdgeInsets.only(left: upperSidePadding,top: upperSidePadding),
                      child: MyText(text: '$dateOfDay', size: 27.0,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: upperSidePadding,top: upperSidePadding),
                      child: MyText(text: '${dbCubit.allTasks.length} Tasks Today', size: 15.0,color: Colors.black38,),
                    ),
                    K_vSpace,
                    //List of date
                    Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: days.length,
                          padding: const EdgeInsets.only(left: upperSidePadding,top: upperSidePadding,bottom: upperSidePadding),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return DayContainer(
                              dayInText: days[index],
                              dayInNumber: index+1 > weekDay ?
                              todayDate.add(Duration(days: (index+1)-weekDay )).day
                                  :
                              todayDate.subtract(Duration(days: (weekDay-(index+1)))).day,

                              firstColor: (index+1) == weekDay ? K_orangeAccentColor : K_whiteColor,
                              secondColor: (index+1) == weekDay ? K_orangeColor : K_whiteColor,
                            );
                          },
                        )
                    ),
                    K_vSpace,
                    //End of The upper side of the column
                    ConditionalBuilder(
                        condition: dbCubit.allTasks.length > 0,
                        fallback: (context) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.doc_plaintext,
                                color: K_blackAccentColor,
                                size: 50.0,
                              ),
                              K_vSpace,
                              MyText(text: 'No Tasks Available', size: 20.0,color: K_pinkColor,),
                            ],
                          ),
                        ),
                        builder: (context) => ListViewOfTasks(tasks: dbCubit.allTasks,appCubit: dbCubit,)
                    ),
                    //Spaces to avoid floating action button
                    K_vSpace,
                    K_vSpace,
                    K_vSpace,
                    K_vSpace,
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
