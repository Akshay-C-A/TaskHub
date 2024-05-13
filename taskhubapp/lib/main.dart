import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskhubapp/auth/login_page.dart';
// import 'package:taskhubapp/auth/login_page.dart';
import 'package:taskhubapp/TeamMember/memberDashboard.dart';
import 'package:taskhubapp/services/notification_services.dart';
import 'package:taskhubapp/teamLeader/leaderDashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();

  runApp(MaterialApp(
    home: LeaderDashboard(),
  ));
}
