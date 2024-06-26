import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskhubapp/services/leaderFirestore.dart';
import 'package:taskhubapp/teamLeader/view_task.dart';

class ProjectMembers extends StatefulWidget {
  final String company;
  const ProjectMembers({super.key, required this.company});

  @override
  State<ProjectMembers> createState() => ProjectMembersState();
}

class ProjectMembersState extends State<ProjectMembers> {
  LeaderFirestore _leaderFirestore = LeaderFirestore();
  final userMail = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Members'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemberSearchPage(
                              company: widget.company,
                              email: userMail.toString(),
                            )));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: StreamBuilder(
          stream: _leaderFirestore.getProjectMembersStream(
              leaderId: userMail.toString()),
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

//                 // NotificationService().showNotification(
//                 //   title: 'Added a New Task',
//                 //   body: data['taskName'],
//                 // );

                // Display as a list title
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ViewTask(
                                  priority: priority,
                                  taskName: taskName,
                                  timestamp: timestamp,
                                  projectName: projectName,
                                  taskId: taskId,
                                  details: details,
                                  leaderName: leaderName,
                                  leaderId: leaderId))));
                    },
                    tileColor: Colors.amber,
                    leading: Text((index + 1).toString()),
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

class MemberSearchPage extends StatefulWidget {
  final String email;
  final String company;
  const MemberSearchPage({
    super.key,
    required this.email,
    required this.company,
  });

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  String name = '';

  void _showAddDialogue(
      String name, String designation, String email, List skills, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to add $name to your project?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseFirestore.instance
                    .collection('teamLeaders')
                    .doc(widget.email)
                    .collection('ProjectMembers')
                    .add({
                  'designation': designation,
                  'email': email,
                  'name': name,
                  'skills': name,
                  'uid': uid,
                });
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('teamMembers').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshots.hasData || snapshots.data == null) {
            return Center(
              child: Text('No data found'),
            );
          }

          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshots.data!.docs[index].data() as Map<String, dynamic>?;

              if (data == null) {
                return Text('data');
              }

              if (name.isEmpty) {
                return GestureDetector(
                  onTap: () {
                    _showAddDialogue(data['name'], data['designation'],
                        data['email'], data['skills'], data['uid']);
                  },
                  child: ListTile(
                    title: Text(
                      data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['email'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              if (data['name']
                  .toString()
                  .toLowerCase()
                  .startsWith(name.toLowerCase())) {
                return GestureDetector(
                  onTap: () {
                    _showAddDialogue(data['name'], data['designation'],
                        data['email'], data['skills'], data['uid']);
                  },
                  child: ListTile(
                    title: Text(
                      data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['email'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
