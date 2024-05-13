import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskhubapp/TeamMember/member_profile_form.dart';
import 'package:taskhubapp/teamLeader/leaderDashboard.dart';
import 'package:taskhubapp/teamMember/memberDashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  String? _emailError;
  String? _passwordError;
  String _userType = 'teamMember';
  bool _isRegisterMode = false;
  Map<String, dynamic>? userType;

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    try {
      // Validate email and password
      if (emailController.text.trim().isEmpty) {
        setState(() {
          _emailError = 'Email is required';
        });
        return;
      }
      if (passwordController.text.trim().isEmpty) {
        setState(() {
          _passwordError = 'Password is required';
        });
        return;
      }

      if (_isRegisterMode) {
        // Register new user
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(emailController.text).set({
          'email': emailController.text.trim(),
          'userType': _userType,
        });

        if (_userType == 'teamLeader') {
          await FirebaseFirestore.instance.collection('teamLeaders').doc(emailController.text).set({
            'email': emailController.text.trim(),
          });
        } else {
          await FirebaseFirestore.instance.collection('teamMembers').doc(emailController.text).set({
            'email': emailController.text.trim(),
          });

          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (userType!['userType'] == 'teamLeader') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LeaderDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MemberProfileForm()),
          );
        }

        
        
        }
      } else {
        // Sign in existing user
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get user type from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(emailController.text).get();

        userType = userSnapshot.data() as Map<String, dynamic>;

        // Navigate to the corresponding dashboard
        if (userType!['userType'] == 'teamLeader') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LeaderDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MemberDashboard()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email') {
          _emailError = 'Invalid email address';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password';
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.message}'),
            ),
          );
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isRegisterMode ? 'REGISTER' : 'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                if (_isRegisterMode)
                  DropdownButtonFormField<String>(
                    value: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'teamMember',
                        child: Text('Team Member'),
                      ),
                      DropdownMenuItem(
                        value: 'teamLeader',
                        child: Text('Team Leader'),
                      ),
                    ],
                  ),
                SizedBox(height: 20.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email id',
                    errorText: _emailError,
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                    errorStyle: TextStyle(color: Colors.red),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                ),
                SizedBox(height: 20.0),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text(_isRegisterMode ? 'Register' : 'Login'),
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegisterMode = !_isRegisterMode;
                      _emailError = null;
                      _passwordError = null;
                      emailController.clear();
                      passwordController.clear();
                    });
                  },
                  child: Text(
                    _isRegisterMode
                        ? 'Already have an account? Login'
                        : 'Don\'t have an account? Register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
