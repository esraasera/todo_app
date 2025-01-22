import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/styles/colors.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type ,
  required String label,
  IconData? prefixIcon,
  IconData? suffixIcon,
  String? Function(String?)? validate,
  Function? onTap,
  context,

}) =>Theme(
  data: Theme.of(context).copyWith(
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: defaultColor,
      selectionHandleColor: defaultColor,
    ),
  ),
  child: TextFormField(
    controller: controller,
   keyboardType: type,
    cursorColor: Colors.black,
    validator: validate,
    onTap: (){
      onTap!();
    },
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color:defaultColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
        color: defaultColor,
        ),
      ),
      prefixIcon: Icon(
          prefixIcon,
        color: defaultColor,
      ),

      suffixIcon: Icon(
          suffixIcon,
      ),
      labelText:label ,
      labelStyle:TextStyle(
        color: defaultColor,
       ) ,
      border: OutlineInputBorder(),
    ),
  ),
);


Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  padding: const EdgeInsets.all(15.0),
  child: Row(
  children: [
  CircleAvatar(
  child: Text(
    '${model['time']}',
    style: TextStyle(
      color: Colors.white,
    ),
  ),
  radius: 40.0,
  backgroundColor: defaultColor,
  ),
  SizedBox(
  width: 10.0,
  ),
  Expanded(
  child: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
    '${model['title']}',
  style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
  ),
  ),
  Text(
    '${model['date']}',
    style: TextStyle(
  fontSize:16.0,
  color: Colors.grey,
  ),
  ),
  ],
  ),
  ),
  Row(
  children: [
  IconButton(
  onPressed:(){
    AppCubit.get(context).updateData(
      status: 'done',
      id: model['id'],
    );
  },
  icon:Icon(
  Icons.check_circle,
  color: Colors.green,
  ),
  ),
  IconButton(
  onPressed:(){
    AppCubit.get(context).updateData(
        status: 'archive',
        id: model['id'],
    );
  },
  icon:Icon(
  Icons.archive_rounded,
  color: Colors.black38,
  ),
  ),
  ],
  ),
  ],
  ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(
      id:model['id'],
    );
  },
);


Widget buildTasks({
  required List tasks,
}) =>  ConditionalBuilder(
  condition: tasks.length> 0 ,
  builder: (BuildContext context) =>ListView.separated(
    itemBuilder:(context, index) => buildTaskItem(tasks[index],context),
    separatorBuilder:(context, index) =>  Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 40.0,
      ),
      child: Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.grey,
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 100.0,
        ),
        Text(
          'No tasks yet, please add some tasks',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  ),
);
