import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoo_app/Bloc/cubit.dart';

Widget taskItem(Map model, context) => Dismissible(
      //مسئوله عن حذف ال data
      key: Key(model['id'].toString()), //ال key هنا  لازم يكون string
      onDismissed: (direction) {
        TodoCubit.get(context).deleteDataBase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 35,
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20,

                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDataBase(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDataBase(status: 'archived', id: model['id']);
              },
              icon: Icon(Icons.archive_outlined, color: Colors.black87),
            ),
          ],
        ),
      ),
    );


Widget TaskBuilder({required List<Map> tasks
})=>ConditionalBuilder(
  condition: tasks.length>0,
  builder: ( context,)=>ListView.separated(
      itemBuilder: (context, index,) => taskItem(tasks[index],context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(13.0),
        child: Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey,
        ),
      ),
      itemCount: tasks.length),
  fallback: (BuildContext context) =>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.grey,),
        Text('Please Add Tasks',
          style: TextStyle(color: Colors.grey,
              fontSize: 30
          ),
        ),
      ],
    ),
  ),

);
