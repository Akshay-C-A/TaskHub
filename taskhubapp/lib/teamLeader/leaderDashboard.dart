import 'package:flutter/material.dart';
import 'package:taskhubapp/teamLeader/sample.dart';

class LeaderDashboard extends StatefulWidget {
  const LeaderDashboard({super.key});

  @override
  State<LeaderDashboard> createState() => LleaderDashboardState();
}

class LleaderDashboardState extends State<LeaderDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[Sample(), Sample(), Sample()];

    return Scaffold(
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
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
