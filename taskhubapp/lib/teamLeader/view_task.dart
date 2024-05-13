import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTask extends StatefulWidget {
  final int priority;
  final String taskName;
  final Timestamp timestamp;
  final String projectName;
  final String taskId;
  final String details;
  final String leaderName;
  final String leaderId;
  String? assignedTo;
  String? state;
  String? commitLast;

  ViewTask({
    super.key, 
    required this.priority, 
    required this.taskName, 
    required this.timestamp, 
    required this.projectName, 
    required this.taskId, 
    required this.details, 
    required this.leaderName, 
    required this.leaderId, 
    this.assignedTo,
    this.state,
    this.commitLast,
    });

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
      ),
      body: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DataTable(border: TableBorder.all(width: 2,style: BorderStyle.solid),
                rows: [
                DataRow(cells: [
                  const DataCell(Text('Task ID')),DataCell(Text(widget.taskId))
                ]),DataRow(cells: [
                  const DataCell(Text('Task Name')),DataCell(Text(widget.taskName))
                ]),DataRow(cells: [
                  const DataCell(Text('Asigned to')),DataCell(Text(widget.assignedTo ?? 'None'))
                ]),DataRow(cells: [
                  const DataCell(Text('State')),DataCell(Text(widget.state ?? 'Nil'))
                ]),DataRow(cells: [
                  const DataCell(Text('Last Commit')),DataCell(Text(widget.commitLast ?? 'Nil'))
                ]),
              ], columns: const [
                DataColumn(label: Text('')),DataColumn(label: Text('')),
              ],),
            ],
          ),
          const SizedBox(height: 20,),
          const Center(child: Text('Previous Commits'),)
          
        ],
      ),
    );
  }
}