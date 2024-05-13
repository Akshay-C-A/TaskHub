import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';




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

  void _navigateToPage(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userMail = user.email;

    // if (userType == 'Student') {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => Student_Dashboard()),
    //   );
    // } else if (userType == 'Alumni') {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => Alumni_Dashboard()),
    //   );
    // } else if (userType == 'Admin') {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => AdminDashboard()),
    //   );
    // } else if (userType == 'Moderator') {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => EventDashboard()),
    //   );
    // } else {
    //   // Handle other user types or invalid emails
    // }
  }
}

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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email') {
          _emailError = 'Invalid email address';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password';
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in: ${e.message}'),
            ),
          );
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => MainPage()),
    // );
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
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
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
                    child: Text('Login'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
