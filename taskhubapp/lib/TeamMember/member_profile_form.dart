import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Member2 {
  String memberId;
  String member_name;
  String project_name;
  String team_lead_name;
  List<dynamic> skills;
  String mail;
  String dpURL;

  Member2({
    required this.memberId,
    required this.member_name,
    required this.project_name,
    required this.team_lead_name,
    required this.skills,
    required this.mail,
    required this.dpURL,
  });
}


class MemberProfileForm extends StatefulWidget {
  @override
  State<MemberProfileForm> createState() => _MemberProfileFormState();
}

class _MemberProfileFormState extends State<MemberProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _memberNameController;
  // late TextEditingController _projectNameController;
  late TextEditingController _skillsController;
    late TextEditingController _mailController;
      late TextEditingController _designationController;
  late List<String> skills = [];


 String? _validateAlphabets(String? value) {
  if (value != null && value.isNotEmpty) {
    // Regular expression to match alphabets and spaces
    final alphaRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!alphaRegex.hasMatch(value)) {
      return 'Only alphabets and spaces are allowed';
    }
  } else {
    return 'This field is required';
  }
  return null;
}

XFile? _selectedImage;
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = path.basename(_selectedImage!.path);
    final imageRef = storageRef.child('student_profile/$fileName');

    try {
      await imageRef.putFile(File(_selectedImage!.path));
      final downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _cancelImageSelection() {
    setState(() {
      _selectedImage = null;
    });
  }

void _resetForm() {
    _memberNameController.clear();
    _designationController.clear();
    _skillsController.clear();
    _mailController.clear();

    setState(() {
      _selectedImage = null;
    });
  }

  @override
void initState() {
  super.initState();
  _memberNameController = TextEditingController();
  _skillsController = TextEditingController();
  _mailController = TextEditingController(); // Initialize _mailController
  _designationController = TextEditingController();
}


  @override
  void dispose() {
    _memberNameController.dispose();
    // _projectNameController.dispose();
    _skillsController.dispose();
    _mailController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save member profile to Firestore or perform any other action
      // Example: FirestoreService().saveMemberProfile(memberProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Member profile saved successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: [
            IconButton(
              onPressed: _submitForm,
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key:_formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      const SizedBox(height: 16.0),
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _memberNameController,
                        validator: _validateAlphabets,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(),
                        ),
                  
                        maxLines: null,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _mailController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'MailId is required';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 16.0),
                      
                      const Text(
                        'Designation',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _designationController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Designation is required';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Enter Current Designation',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _skillsController,
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skills are required';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Enter Skills',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      
                      const SizedBox(height: 16.0),
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _pickImage,
                            icon: Icon(Icons.upload_file),
                          ),
                          if (_selectedImage != null)
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _cancelImageSelection,
                                    icon: const Icon(Icons.cancel),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                      const SizedBox(height: 16.0),
                      IconButton(
                        onPressed: _resetForm,
                        icon: Icon(Icons.delete),
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
