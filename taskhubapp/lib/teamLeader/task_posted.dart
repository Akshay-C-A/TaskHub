import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskhubapp/services/leaderFirestore.dart';
import 'package:taskhubapp/services/notification_services.dart';

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
        actions: const [
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

                bool notified = data['notified'] ?? true;
                Timestamp timestamp = data['timestamp'];
                // List<String> enrolled =
                //     List<String>.from(data['enrolled'] ?? []);

                // if (notified == false) {
                NotificationService().showNotification(
                  title: 'Added a New Task',
                  body: data['taskName'],
                );
                // List ref = firestoreService.eventPostInstances(
                //     postId: document.id, moderatorId: moderatorId);
                // DocumentReference eventPost = ref[0];
                // DocumentReference moderatorProfile = ref[1];

                // eventPost.update({'notified': true});
                // moderatorProfile.update({'notified': true});
                // }

                // Display as a list title
                return ListTile();
              },
            );
          }),
    );
  }
}
