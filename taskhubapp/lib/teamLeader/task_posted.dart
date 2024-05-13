import 'package:flutter/material.dart';

class TaskPosted extends StatefulWidget {
  const TaskPosted({super.key});

  @override
  State<TaskPosted> createState() => _TaskPostedState();
}

class _TaskPostedState extends State<TaskPosted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              child: Icon(Icons.abc),
            ),
          )
        ],
      ),
    );
  }
}
