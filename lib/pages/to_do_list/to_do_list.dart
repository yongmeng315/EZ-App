import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Title',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Description',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Priority',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Status',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Due Date',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),

        Divider(
          thickness: 2,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Title',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Description',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Priority',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Status',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Text(
                'Due Date',
                style: Theme
                    .of(
                  context,
                )
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),


      ],
    );
  }
}
