
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/AppDataBaseCubit.dart';
import 'package:todo_app/AppCubits/AppDatabaseCubit/States.dart';
import 'package:todo_app/AppCubits/NavBarCubit/NavBarCubit.dart';
import 'package:todo_app/AppCubits/NavBarCubit/States.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/AddNewTaskContainer.dart';
import 'package:todo_app/MyWidgets/MyButton.dart';
import 'package:todo_app/MyWidgets/MyText.dart';
import 'package:todo_app/MyWidgets/MyTextField.dart';
import 'package:todo_app/MyWidgets/TaskContainer.dart';
import 'package:todo_app/Screens/ArchivedScreen.dart';
import 'package:todo_app/Screens/DoneScreen.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/ReminderScreen.dart';
import 'package:todo_app/Shared/BottomSheet.dart';
import 'package:todo_app/main.dart';

class NavigationPage extends StatelessWidget {


  List<Widget> screens = [
    HomeScreen(),
    DoneScreen(),
    ArchivedScreen(),
    ReminderScreen(),
  ];

  List<String> appBarTitle = [
    'My Tasks',
    'Done Tasks',
    'Archived Tasks',
    'Reminders',
  ];

  static double heightOfDevice = 0;
  static double widthOfDevice = 0;

  @override
  Widget build(BuildContext context) {
    heightOfDevice = MediaQuery.of(context).size.height;
    widthOfDevice = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => NavBarCubit(),
      child: BlocConsumer<NavBarCubit, NavBarStates>(
        listener: (context, state){

        },
        builder: (context , state){
          NavBarCubit appCubit = NavBarCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70.0,
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyText(text: appBarTitle[appCubit.mainIndex], size: 25.0,color: K_blackAccentColor,),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: false
            ),
            body: screens[appCubit.mainIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appCubit.mainIndex,
              onTap: (value){
                appCubit.changeMainIndex(value);
              },
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: K_pinkColor,
              unselectedItemColor: K_greyColor,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.square_grid_2x2_fill,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Ionicons.checkmark_done_circle
                    ),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.archivebox_fill,
                    ),
                    label: 'Archived'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Ionicons.notifications
                    ),
                    label: 'Reminders'
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
