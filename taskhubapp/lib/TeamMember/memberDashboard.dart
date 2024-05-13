import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskhubapp/TeamMember/member_profile.dart';
// import 'package:taskhubapp/TeamMember/member_profile.dart';
import 'package:taskhubapp/TeamMember/member_profile_form.dart';
// import 'package:taskhubapp/TeamMember/member_profile_form.dart';
import 'package:taskhubapp/auth/login_page.dart';
import 'package:taskhubapp/chat_app/pages/home_page.dart';
import 'package:taskhubapp/services/memberFirestore.dart';
import 'package:taskhubapp/teamLeader/sample.dart';
// import 'package:taskhubapp/teamMember/member_profile.dart';

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
      floatingActionButton: Badge(
        isLabelVisible: true,
        backgroundColor: Colors.red,
        label: Text('1'),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatHomePage()));
          },
          child: Icon(Icons.chat),
        ),
      ),
      appBar: AppBar(
                    title: Text('Team Member'),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    member: Member2(
                                  member_name: member_name,
                                  memberId: memberId,
                                  project_name: project_name,
                                  team_lead_name: team_lead_name,
                                  skills: skills,
                                  mail: mail,
                                  dpURL: dpURL,
                                )),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(dpURL),
                            radius: 20.0,
                          ),
                        ),
                      ),
                    ],
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
