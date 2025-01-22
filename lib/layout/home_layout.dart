import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/styles/colors.dart';

class HomeLayout extends StatelessWidget{
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child:BlocConsumer<AppCubit,AppStates> (
        listener: (context,state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return  SafeArea(
            child: Scaffold(
              key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60.0,
              backgroundColor:defaultColor,
            title: Text(
            cubit.titles[cubit.currentIndex],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            ),
            floatingActionButton:FloatingActionButton(
            child: Icon(
            cubit.navBarIcon,
              color: Colors.white,
            ),
            backgroundColor: defaultColor,
            onPressed: () {
              if (cubit.isButtomSheetShown){
                if(formKey.currentState!.validate()){
                  cubit.insertToDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  ).then((value){
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                  });
                }
              }else {
                scaffoldKey.currentState!.showBottomSheet((context) =>
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                prefixIcon: Icons.title,
                                context:context,
                                onTap:(){},
                                label: 'Task Title',
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'title must not be embty';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            defaultTextFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                label: 'Task Time',
                                context:context,
                                prefixIcon: Icons.watch_later_outlined,
                                onTap:(){
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: defaultColor,
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  ).then((value) {
                                    timeController.text= value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                } ,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be embty';
                                  }
                                  return null;
                                }
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            defaultTextFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Task date',
                                context:context,
                                prefixIcon: Icons.archive,
                                onTap:(){
                                   showDatePicker(
                                       context: context,
                                       initialDate: DateTime.now(),
                                       firstDate: DateTime.now(),
                                       lastDate: DateTime.parse("2025-12-31"),
                                     builder: (BuildContext context, Widget? child) {
                                       return Theme(
                                         data: Theme.of(context).copyWith(
                                           colorScheme: ColorScheme.light(
                                             primary: defaultColor,
                                             onPrimary: Colors.white,
                                             onSurface: Colors.black,
                                           ),
                                         ),
                                         child: child!,
                                       );
                                     },
                                   ).then((value) {
                                     dateController.text = DateFormat.yMMMd().format(value!);
                                     print( DateFormat.yMMMd().format(value));
                                   });
                                } ,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be embty';
                                  }
                                  return null;
                                }
                            ),


                          ],
                        ),
                      ),
                    ),

                ).closed.then((value){
                  cubit.changeButtomSheetShown(
                    icon: Icons.add,
                    isShown: false,
                  );
                });
                cubit.changeButtomSheetShown(
                    icon: Icons.edit,
                    isShown: true,
                );

              }
            },
            ),
            bottomNavigationBar:  BottomNavigationBar(
              backgroundColor: Colors.white,
            type:BottomNavigationBarType.fixed,
            currentIndex:cubit.currentIndex ,
            elevation: 5.0,
            selectedItemColor:defaultColor,
            onTap:(index){
            cubit.changeBottomNavBar(index);
            } ,
            items: [
            BottomNavigationBarItem(
            icon: Icon(
            Icons.menu,
            ),
            label: 'New',
            ),
            BottomNavigationBarItem(
            icon: Icon(
            Icons.check_circle_outlined,
            ),
            label: 'done',
            ),
            BottomNavigationBarItem(
            icon: Icon(
            Icons.archive_outlined,
            ),
            label: 'archived',
            ),
            ],
            ),
              body: ConditionalBuilder(
                  condition: state is! AppGetDatabaseLoadingState,
                  builder: (context) => cubit.screens[cubit.currentIndex],
                  fallback: (context)=> Center(child: CircularProgressIndicator(
                    color: Colors.teal.shade400,
                  )),
              ),
            ),
          );
        },
      )

    );

  }






}