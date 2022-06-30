import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_app/Bloc/cubit.dart';
import 'package:todoo_app/Bloc/states.dart';

import '../../components.dart';

class Archived extends StatelessWidget {
  const Archived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          var tasks = TodoCubit.get(context).archived;
          return TaskBuilder(tasks: tasks);
        });
  }
}
