import 'package:flutter/material.dart';
import 'package:taskhubapp/services/leaderFirestore.dart';

class AddTaskPage extends StatefulWidget {
  final String projectName;
  final String leaderId;
  final String leaderName;
  const AddTaskPage({
    super.key,
    required this.projectName,
    required this.leaderId,
    required this.leaderName,
  });

//   @override
//   State<AddTaskPage> createState() => _AddTaskPageState();
// }

class _AddTaskPageState extends State<AddTaskPage> {
  final LeaderFirestore _leaderService = LeaderFirestore();
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  final _taskTitleController = TextEditingController();
  final _taskPriorityController = TextEditingController();

  void _resetForm() {
    _detailsController.clear();
    _taskTitleController.clear();
    _taskPriorityController.clear();
    setState(() {});
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      _leaderService.addTasks(
          projectName: widget.projectName,
          taskName: _taskTitleController.text,
          leaderId: widget.leaderId,
          leaderName: widget.leaderName,
          details: _detailsController.text,
          priority: int.parse(_taskPriorityController.text));
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter the details correctly'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        actions: [
          TextButton(
              onPressed: _submitPost,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('Submit'),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Priority',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _taskPriorityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Priority is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Priority must be a number ranging from 1-10';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Priority from 1-10',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Task Title',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _taskTitleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Add your caption',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Task Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _detailsController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter details',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  IconButton(onPressed: _resetForm, icon: Icon(Icons.delete)),
                ],
              ),
            )),
      ),
    );
  }
}
