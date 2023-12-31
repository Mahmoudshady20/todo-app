import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/mydatabase.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/component/dialog_utils.dart';
import 'package:todo/ui/home_screen/list_screen/edit_task.dart';


class TaskItem extends StatefulWidget {

  Task task;
  TaskItem({required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    var providr = Provider.of<AuthProvider>(context);
    return Container(
      margin: const EdgeInsets.all(12),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .25,
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              onPressed: (BuildContext){
                deleteTask();
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              onPressed: (BuildContext){
                DialogUtils.showMessage(context, 'Do you want to edit this task?',
                    postActionName: 'Yes',
                    posAction: (){
                      Navigator.pushNamed(context,EditTask.routeName,
                          arguments: widget.task);
                    },
                    negActionName: 'Cancel'
                );
              },
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 80,
                decoration: BoxDecoration(
                    color: widget.task.isDone ?? true  ? Color(0xFF61E757) :  Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(12))
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.title ?? '', style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold, color: widget.task.isDone ?? true  ? Color(0xFF61E757) :  Theme.of(context).primaryColor),
                      ),
                      SizedBox(height: 18,),
                      Text(widget.task.desc ?? ''),
                    ],
                  )
              ),
              InkWell(
                onTap: (){
                  widget.task.isDone = true;
                  MyDataBase.updateTask(providr.myUser!.id ?? '',widget.task);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: widget.task.isDone ?? true  ? Color(0xFF61E757) :   Theme.of(context).primaryColor,
                  ),
                  child: widget.task.isDone ?? true ? Text('Done!') :  Icon(Icons.check_outlined, color: Colors.white,size: 24) ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask(){
    DialogUtils.showMessage(context, 'Do you want to delete this task?',
        postActionName: 'Yes',
        posAction: () async{
          deleteTaskFromDataBase();
        },
        negActionName: 'Cancel'
    );
  }
  void deleteTaskFromDataBase()async{
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    try{
      await MyDataBase.deleteTask(authProvider.myUser?.id??"",
          widget.task);
    }catch(e){
      DialogUtils.showMessage(context, 'something went wrong,'
          '${e.toString()}',);
    }
  }

}

