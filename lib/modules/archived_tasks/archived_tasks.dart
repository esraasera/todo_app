import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchiveTasks extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return buildTasks(
            tasks: tasks
        );
      },

    );
  }

}