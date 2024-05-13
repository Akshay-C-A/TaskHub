import 'package:flutter/material.dart';
import 'package:taskhubapp/teamLeader/addTask.dart';
import 'package:taskhubapp/teamLeader/sample.dart';
import 'package:taskhubapp/teamLeader/task_posted.dart';

class LeaderDashboard extends StatefulWidget {
  const LeaderDashboard({super.key});

  @override
  State<LeaderDashboard> createState() => LleaderDashboardState();
}

class LleaderDashboardState extends State<LeaderDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const TaskPosted(leaderId: 'leader@company.com',),
      const AddTaskPage(
        projectName: '123B65',
        leaderId: '',
        leaderName: 'Sundar Piche',
      ),
      const Sample()
    ];

    return Scaffold(
      
      floatingActionButton: Badge(
        isLabelVisible: true,
        backgroundColor: Colors.red,
        label: Text('1'),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.chat),
        ),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            label: 'Add Member',
          ),
        ],
      ),
    );
  }
}
