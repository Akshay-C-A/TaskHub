import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskhubapp/auth/login_page.dart';
import 'package:taskhubapp/services/leaderFirestore.dart';
import 'package:taskhubapp/services/notification_services.dart';
import 'package:taskhubapp/teamLeader/view_task.dart';

class TaskPosted extends StatefulWidget {
  final String leaderId;
  const TaskPosted({
    super.key,
    required this.leaderId,
  });

  @override
  State<TaskPosted> createState() => _TaskPostedState();
}

class _TaskPostedState extends State<TaskPosted> {
  LeaderFirestore _leaderFirestore = LeaderFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          TextButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              // Navigate to the MainPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            } catch (e) {
              print('Error signing out: $e');
            }
          },
          child: Text('LogOut'),
        ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              child: Icon(Icons.abc),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _leaderFirestore.getTasksStream(leaderId: widget.leaderId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            List eventPostList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: eventPostList.length,
              itemBuilder: (context, index) {
                // Get each individual doc
                DocumentSnapshot document = eventPostList[index];
                // String docID = document.id;

                // Get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                int priority = data['priority'];
                String taskName = data['taskName'];
                Timestamp timestamp = data['timestamp'];
                String projectName = data['projectName'];
                String taskId = data['taskId'];
                String details = data['details'];
                String leaderName = data['leaderName'];
                String leaderId = data['leaderId'];

               
                // NotificationService().showNotification(
                //   title: 'Added a New Task',
                //   body: data['taskName'],
                // );
                
                // Display as a list title
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => ViewTask(priority: priority, taskName: taskName, timestamp: timestamp, projectName: projectName, taskId: taskId, details: details, leaderName: leaderName, leaderId: leaderId))));
                    },
                    tileColor: Colors.amber,
                    leading: Text((index+1).toString()),
                    title: Text(taskName),
                    subtitle: Text(details),
                    trailing: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Text(priority.toString()),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
