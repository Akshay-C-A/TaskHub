import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskhubapp/teamMember/member_profile_form.dart';
import 'package:taskhubapp/teamLeader/leaderDashboard.dart';
import 'package:taskhubapp/teamMember/memberDashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final skillsController = TextEditingController();
  final companyNameController = TextEditingController(); // Added company name controller
  bool _isLoading = false;
  bool _isObscure = true;
  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _designationError;
  String? _skillsError;
  String? _companyNameError; // Added company name error
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
        if (nameController.text.trim().isEmpty) {
          setState(() {
            _nameError = 'Name is required';
          });
          return;
        }
        if (designationController.text.trim().isEmpty) {
          setState(() {
            _designationError = 'Designation is required';
          });
          return;
        }
        if (skillsController.text.trim().isEmpty) {
          setState(() {
            _skillsError = 'Skills are required';
          });
          return;
        }
        if (companyNameController.text.trim().isEmpty) { // Check if company name is empty
          setState(() {
            _companyNameError = 'Company name is required';
          });
          return;
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Registered'),
            duration: Duration(seconds: 3),
          ),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(emailController.text)
            .set({
              'uid': await FirebaseAuth.instance.currentUser!.uid,
          'email': emailController.text.trim(),
          'userType': _userType,
          'name': nameController.text.trim(),
          'designation': designationController.text.trim(),
          'skills': skillsController.text.trim().split(',').map((skill) => skill.trim()).toList(),
          'companyName': companyNameController.text.trim(), // Add company name to Firestore
        });

        if (_userType == 'teamLeader') {
          await FirebaseFirestore.instance
              .collection('teamLeaders')
              .doc(emailController.text)
              .set({
            'uid': await FirebaseAuth.instance.currentUser!.uid,
            'email': emailController.text.trim(),
            'name': nameController.text.trim(),
            'designation': designationController.text.trim(),
            'skills': skillsController.text.trim(),
            'companyName': companyNameController.text.trim(), // Add company name to Firestore
          });
        } else {
          await FirebaseFirestore.instance
              .collection('teamMembers')
              .doc(emailController.text)
              .set({
            'uid': await FirebaseAuth.instance.currentUser!.uid,
            'email': emailController.text.trim(),
            'name': nameController.text.trim(),
            'designation': designationController.text.trim(),
            'skills': skillsController.text.trim(),
            'companyName': companyNameController.text.trim(), // Add company name to Firestore
          });

          userType = {
            'userType': _userType,
          };

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
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(emailController.text)
            .get();

        userType = userSnapshot.data() as Map<String, dynamic>;

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
    nameController.dispose();
    designationController.dispose();
    skillsController.dispose();
    companyNameController.dispose(); // Dispose the company name controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  if (_isRegisterMode)
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            errorText: _nameError,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: designationController,
                          decoration: InputDecoration(
                            labelText: 'Designation',
                            errorText: _designationError,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: skillsController,
                          decoration: InputDecoration(
                            labelText: 'Skills',
                            errorText: _skillsError,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: companyNameController,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            errorText: _companyNameError,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
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
                        _nameError = null;
                        _designationError = null;
                        _skillsError = null;
                        _companyNameError = null;
                        emailController.clear();
                        passwordController.clear();
                        nameController.clear();
                        designationController.clear();
                        skillsController.clear();
                        companyNameController.clear();
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
      ),
    );
  }
}
