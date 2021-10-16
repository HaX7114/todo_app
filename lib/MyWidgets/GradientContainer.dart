import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/MyText.dart';

class GradientContainer extends StatelessWidget {
  final firstColor;
  final secondColor;
  final title;
  final icon;
  final numOfTasks;
  final height;

  const GradientContainer({Key? key,this.height,this.title,this.icon,this.firstColor,this.secondColor,this.numOfTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 10),
              color: secondColor,
              blurRadius: 20.0
          )
        ],
        borderRadius: BorderRadius.circular(K_radius + 5),
        gradient: LinearGradient(
          colors: [firstColor,secondColor],
          stops: [0.1,0.9],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 45.0,
              color: K_whiteColor,
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: MyText(text: title, size: 15.0,color: K_whiteColor,fontWeight: FontWeight.w600,)),
              ],
            ),
            MyText(text: '$numOfTasks Tasks', size: 13.0,fontWeight: FontWeight.w400,color: K_whiteColor,)
          ],
        ),
      ),
    );
  }
}
