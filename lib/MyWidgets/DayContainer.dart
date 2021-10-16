import 'package:flutter/material.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/MyText.dart';


//Used in TodayTasks
class DayContainer extends StatelessWidget {

  final dayInNumber;
  final dayInText;
  Color firstColor;
  Color secondColor;

  DayContainer({Key? key,this.firstColor = K_whiteColor, this.secondColor = K_whiteColor, this.dayInNumber,this.dayInText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0,bottom: 10.0,top: 10.0),
      child: Container(
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(K_radius+20),
          boxShadow: [
            BoxShadow(
                color: secondColor == K_whiteColor ? K_whiteColor : secondColor,
                blurRadius: secondColor == K_whiteColor ? 0.0 : 13.0
            )
          ],
          gradient: LinearGradient(
            colors: [firstColor,secondColor],
            stops: [0.1,0.9],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                  text: '$dayInNumber',
                  size: 30.0,
                  color: secondColor == K_whiteColor ? K_blackColor : K_whiteColor,
              ),
              SizedBox(height: 5,),
              MyText(
                text: '$dayInText',
                size: 18.0,
                color: secondColor == K_whiteColor ? K_blackColor : K_whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
