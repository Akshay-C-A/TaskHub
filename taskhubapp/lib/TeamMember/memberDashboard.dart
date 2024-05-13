import 'package:flutter/material.dart';
import 'package:taskhubapp/services/memberFirestore.dart';
import 'package:taskhubapp/teamLeader/sample.dart';

class Member {
  String memberId;
  String member_name;
  String project_name;
  String team_lead_name;
  List<dynamic> skills;
  String mail;
  String dpURL;

  Member({
    required this.memberId,
    required this.member_name,
    required this.project_name,
    required this.team_lead_name,
    required this.skills,
    required this.mail,
    required this.dpURL,
  });
}

class MemberDashboard extends StatefulWidget {
  const MemberDashboard({Key? key}) : super(key: key);

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  int _selectedIndex = 0;
  late String memberId;
  late String member_name;
  late String project_name;
  late String team_lead_name;
  late List<dynamic> skills;
  late String mail;
  late String dpURL;

  Future<void> _fetchDetails() async {
    try {
      final postSnapshot = await MemberFirestore.getMember(
        memberId: memberId,
      );

      if (postSnapshot.exists) {
        final postData = postSnapshot.data() as Map<String, dynamic>;

        setState(() {
          member_name = postData['memberName'] as String;
          project_name = postData['projectName'] as String;
          team_lead_name = postData['teamLeadName'] as String;
          skills = (postData['skills'] as List<dynamic>).cast<String>();
          mail = postData['mail'] as String;
          dpURL = postData['dpURL'] as String;
        });
      } else {
        setState(() {
          member_name = 'John Doe';
          project_name = 'One Cochin';
          team_lead_name = 'XYZ';
          skills = ['Null'];
          mail = 'example@mail.com';
          dpURL = 'example.com/image.jpg';
        });
      }
    } catch (e) {
      print('Error fetching details: $e');
      setState(() {
        member_name = 'John Doe';
        project_name = 'One Cochin';
        team_lead_name = 'XYZ';
        skills = ['Null'];
        mail = 'example@mail.com';
        dpURL = 'example.com/image.jpg';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    memberId = 'example@mail.com'; // Set member ID here
    _fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      Sample(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(member_name),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
