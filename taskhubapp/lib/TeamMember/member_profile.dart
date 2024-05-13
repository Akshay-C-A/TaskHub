import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskhubapp/TeamMember/member_profile_form.dart';
// import 'package:taskhubapp/teamMember/memberDashboard.dart';
// import 'package:taskhubapp/teamMember/member_profile_form.dart';
import 'package:taskhubapp/auth/login_page.dart';

class ProfileScreen extends StatefulWidget {
  final Member2 member;

  ProfileScreen({required this.member});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isAvailable = true; 
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.member.member_name),
          actions: [
            IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberProfileForm(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * .10),
              Padding(
  padding: EdgeInsets.fromLTRB(width * .08, 0, width * .08, 0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(35),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              widget.member.dpURL,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      SizedBox(height: 12), // Adjust spacing as needed
      Text(
        widget.member.member_name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24, // Decreased font size
        ),
      ),
      SizedBox(height: 8), // Adjust spacing as needed
      Text(
        widget.member.project_name, // Display team lead name separately
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.grey, // You can adjust color as needed
        ),
      ),
      SizedBox(height: 16), // Adjust spacin
                             // Switch button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Text(
                      'Unavailable',
                      style: TextStyle(
                        color: isAvailable ? Colors.grey : Colors.black,
                      ),
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                    Text(
                      'Available',
                      style: TextStyle(
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.member.mail,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team Lead Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.member.team_lead_name,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * .08, width * 0.03, width * .08, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: width * 0.08),
                    Column(
                      children: [
                        Text(
                          'Skills',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: widget.member.skills
                              .map((skill) => Chip(
                                    label: Text(skill),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
