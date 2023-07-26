import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/mydatabase.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/provider/settings_provider.dart';
import 'package:todo/ui/component/date_utils.dart';
import 'package:todo/ui/home_screen/list_screen/task_item.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    var settings = Provider.of<SettingsProvider>(context);
    return Container(
      child: Column(
        children: [
          Container(
            color: settings.themeMode == ThemeMode.light ? Colors.transparent : Theme.of(context).primaryColor,
            child: TableCalendar(
              focusedDay: focusedDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDate = selectedDay;
                  this.focusedDate = focusedDay;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Task>>(
              stream: MyDataBase.getTask(authprovider.myUser?.id ?? '',MyDateUtils.dateOnly(selectedDate).millisecondsSinceEpoch),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                var taskList = snapshot.data?.docs.map((doc) => doc.data()).toList();
                return ListView.builder(itemBuilder:(context, index) => TaskItem(task: taskList![index]),
                  itemCount: taskList?.length ?? 0,
                );
              },
            ),
          ),
        ],
      ),
    );;
  }
}
