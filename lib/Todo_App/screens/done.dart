import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_app/Bloc/cubit.dart';
import 'package:todoo_app/Bloc/states.dart';
import 'package:todoo_app/components.dart';



class Done extends StatelessWidget {
  const Done({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
        listener: ( context, state) {},
        builder: ( context, state) {
          var tasks = TodoCubit.get(context).done;
          return TaskBuilder(tasks: tasks);
        });
  }
}
