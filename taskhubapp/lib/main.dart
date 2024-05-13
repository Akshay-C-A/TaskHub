import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskhubapp/auth/login_page.dart';
// import 'package:taskhubapp/auth/login_page.dart';
import 'package:taskhubapp/TeamMember/memberDashboard.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Permission.photos.request();
  await Permission.storage.request();

  

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

