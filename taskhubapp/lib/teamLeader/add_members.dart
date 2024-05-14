import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskhubapp/services/leaderFirestore.dart';

class ProjectMembers extends StatefulWidget {
  const ProjectMembers({super.key});

  @override
  State<ProjectMembers> createState() => ProjectMembersState();
}

class ProjectMembersState extends State<ProjectMembers> {
  LeaderFirestore _leaderFirestore = LeaderFirestore();
  final userMail = FirebaseAuth.instance.currentUser!.email; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _leaderFirestore.getProjectMembersStream(leaderId: userMail.toString()),
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


class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage({super.key});

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage> {
  String name = '';

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
        stream: FirebaseFirestore.instance.collection('teamMembers').snapshots(),
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
                return SizedBox.shrink();
              }

              bool isAlumni = false;
              if (data['studentId'] == null) {
                isAlumni = true;
              }

              

              if (name.isEmpty) {
                return GestureDetector(
                  onTap: () {
                    if (data['studentId'] == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAlumniProfile(
                                  alumniId: data['alumniId'])));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewStudentProfile(
                                  studentId: data['studentId'])));
                    }
                  },
                  child: ListTile(
                    title: Text(
                      isAlumni
                          ? "${data['alumniName']} • ALUMNI"
                          : "${data['studentName']} • STUDENT",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['studentDesignation'] ?? data['alumniDesignation'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['dpURL']),
                    ),
                  ),
                );
              }

              if (data['studentName']
                      .toString()
                      .toLowerCase()
                      .startsWith(name.toLowerCase()) ||
                  data['alumniName']
                      .toString()
                      .toLowerCase()
                      .startsWith(name.toLowerCase())) {
                return GestureDetector(
                  onTap: () {
                    if (data['studentId'] == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAlumniProfile(
                                  alumniId: data['alumniId'])));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewStudentProfile(
                                  studentId: data['studentId'])));
                    }
                  },
                  child: ListTile(
                    title: Text(
                      isAlumni
                          ? "${data['alumniName']} • ALUMNI"
                          : "${data['studentName']} • STUDENT",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['studentDesignation'] ?? data['alumniDesignation'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['dpURL']),
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
