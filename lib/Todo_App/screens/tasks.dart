import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_app/Bloc/cubit.dart';
import 'package:todoo_app/Bloc/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../../components.dart';

class Tasks extends StatelessWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          var tasks = TodoCubit.get(context).taskss;
          return TaskBuilder(tasks: tasks);
        });
  }
}
