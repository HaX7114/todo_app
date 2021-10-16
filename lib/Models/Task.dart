import 'package:flutter/material.dart';

class Task{

  String? title;
  String? time;
  String? endTime;
  String? date;
  String? status;

  Task({this.title,this.time,this.endTime,this.date,this.status});



}

//Task status
const K_newStatus = 'NEW';
const K_archivedStatus = 'ARCHIVED';
const K_doneStatus = 'DONE';
const K_reminderStatus = 'REMINDER';