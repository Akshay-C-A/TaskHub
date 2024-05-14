import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaderFirestore {
  CollectionReference _leaderTasks =
      FirebaseFirestore.instance.collection('tasks');
  
  // CollectionReference _team = FirebaseFirestore.collection('teamMembers').doc(userMail).collection('ProjectMembers');

  CollectionReference _leaderMember =
      FirebaseFirestore.instance.collection('teamLeaders');

  Future<void> addTasks({
    required String projectName,
    required String taskName,
    required String leaderId,
    required String leaderName,
    required String details,
    required int priority,
  }) async {
    String unique = DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now());
    _leaderTasks.doc('$leaderId').collection('tasks').doc(unique).set({
      'taskId': unique,
      'projectName': projectName,
      'taskName': taskName,
      'leaderId': leaderId,
      'leaderName': leaderName,
      'details': details,
      'priority': priority,
      'timestamp': Timestamp.now(),
    });

    // //Adding post to alumni user data
    // DocumentReference Moderator = moderator.doc(moderatorId);
    // return Moderator.collection('posts').doc('$moderatorId$unique').set({
    //   'eventTitle': EventTitle,
    //   'moderatorId': moderatorId,
    //   'moderatorName': moderatorName,
    //   'date': Date,
    //   'venue': Venue,
    //   'otherDetails': otherDetails,
    //   'imageURL': imageURL,
    //   'timestamp': Timestamp.now(),
    //   'notified': false,
    // });
  }

  // To get the data for moderator posts
  Stream<QuerySnapshot> getTasksStream({required String leaderId}) {
    final tasksStream = _leaderTasks
        .doc('$leaderId')
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return tasksStream;
  }

  Stream<QuerySnapshot> getProjectMembersStream({required String leaderId}) {
    final projectMembersStream =
        _leaderMember.doc(leaderId).collection('ProjectMembers').snapshots();
    return projectMembersStream;
  }
}
