import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/mydatabase.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/component/custom_form_field.dart';
import 'package:todo/ui/component/date_utils.dart';


class EditTask extends StatefulWidget {
  static const String routeName = 'edittask';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var formKey = GlobalKey<FormState>();

  TextEditingController? titleController;

  TextEditingController? descriptionController;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Task;
    titleController = TextEditingController(text: args.title);
    descriptionController = TextEditingController(text: args.desc);
    var provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar:   AppBar(
        title: Text('Edit Task',
        style: Theme.of(context).textTheme.headline4,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.75,
          width: MediaQuery.of(context).size.width*0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomFormField(
                  controller: titleController!,
                  label: 'Task title',
                  validator: (text){
                    if(text==null || text.trim().isEmpty){
                      return 'please enter task title';
                    }
                  },
                ),
                CustomFormField(label: 'Task description',
                    validator: (text){
                      if(text==null || text.trim().isEmpty){
                        return 'please enter task description';
                      }
                    },
                    lines: 5,
                    controller: descriptionController!
                ),
                const SizedBox(height: 12,),
                const Text('Task Date'),
                InkWell(
                  onTap: (){
                    showTaskDatePicker();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black54)
                        )
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(MyDateUtils.formatTaskDate(selectedDate),style: const TextStyle(
                      fontSize: 18,
                    ),),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16)
                    ),
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        args.title = titleController?.text;
                        args.desc = descriptionController?.text;
                        args.date = MyDateUtils.dateOnly(selectedDate);
                        MyDataBase.updateTask(provider.myUser?.id ?? '', args);
                        Navigator.pop(context);
                      }
                    }, child: const Text('Update Task',
                  style: TextStyle(fontSize: 18),))
              ],
            ),
          ),
        ),
      ),
    );
  }

  var selectedDate = DateTime.now();

  void showTaskDatePicker()async{
    var date = await showDatePicker(context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if(date==null)return;

    selectedDate = date;
    setState(() {

    });
  }
}
