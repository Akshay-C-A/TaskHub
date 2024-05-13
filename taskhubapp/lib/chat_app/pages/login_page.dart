
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:taskhubapp/chat_app/components/my_button.dart';
import 'package:taskhubapp/chat_app/components/my_text_field.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap()});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void signIn()async {
    //get the auth service
    final authService = FirebaseAuth.instance;

  try{
    await authService.signInWithEmailAndPassword(
       email: emailController.text, password:passwordController.text ,
      );
  } catch(e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height:50),
          
                  //logo
                  Icon(
                    Icons.message,
                    size: 100,
                    color: Colors.grey[800],
                  ),
              
                  const SizedBox(height: 50),
                  //welcome back message
                  const Text(
                    "Welocome backyou've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
              
                const SizedBox(height: 25),
                  //email textfield
                  MyTextField(
                    controller: emailController, 
                    hintText: 'Email', 
                    obscureText: false, 
                    ),
          
                  const SizedBox(height: 10),
                  //password textfield
                    MyTextField(
                    controller: passwordController, 
                    hintText: 'Password', 
                    obscureText: true, 
                    ),
          
                    const SizedBox(height: 25),
              
                  //sign in button
                  MyButton(
                    onTap: signIn, 
                    text: "Sign In",
                    ),
                    const SizedBox(height: 50),
              
                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                            'Register now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  
                    ],
                  ),
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}