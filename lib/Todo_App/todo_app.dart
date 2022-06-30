import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoo_app/Bloc/cubit.dart';
import 'package:todoo_app/Bloc/states.dart';

class TodoApp extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDataBase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'TodoApp',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black26,
              onTap: (index) {
                cubit.changeBtmNavbar(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_done_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertDataBase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text)
                        .then((value) {
                      Navigator.pop(context);
                      cubit.changeFabSheet(isShow: false, fabIcon: Icons.edit);
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Container(
                            color: Colors.grey.shade200,
                            height: 360,
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      onTap: () {},
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        label: Text('Task Title'),
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please write title';
                                        }
                                      }),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                      controller: timeController,
                                      decoration: const InputDecoration(
                                        label: Text('Task Time'),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please write Time';
                                        }
                                      }),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2030-08-20'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(
                                                  value!); //لازم علامه التعجب دي علشان الايرور
                                        });
                                      },
                                      controller: dateController,
                                      decoration: const InputDecoration(
                                        label: Text('Task Date'),
                                        prefixIcon: Icon(Icons.date_range),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please write date';
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ))
                      .closed // دي لو قفلنا  يقفل ويغير  ال bottom sheet
                      .then((value) {
                    cubit.changeFabSheet(isShow: false, fabIcon: Icons.edit);
                  });
                  cubit.changeFabSheet(
                    isShow: true,
                    fabIcon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.icon),
              backgroundColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class TextForm extends StatelessWidget {
  const TextForm({
    Key? key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    required this.textType,
    required this.validate,
    required this.press,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final TextInputType textType;
  final Function validate;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTap: () {},
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          prefixIcon: Icon(prefixIcon),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        keyboardType: textType,
        validator: validate());
  }
}
