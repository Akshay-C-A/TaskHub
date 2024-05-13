import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemberProfileForm extends StatefulWidget {
  @override
  State<MemberProfileForm> createState() => _MemberProfileFormState();
}

class _MemberProfileFormState extends State<MemberProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _memberNameController;
  late TextEditingController _projectNameController;
  late TextEditingController _skillsController;


  @override
  void initState() {
    super.initState();
    _memberNameController = TextEditingController();
    _projectNameController = TextEditingController();
    _skillsController = TextEditingController();
  }

  @override
  void dispose() {
    _memberNameController.dispose();
    _projectNameController.dispose();
    _skillsController.dispose();
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
          title: Text('Member Profile'),
          actions: [
            IconButton(
              onPressed: _submitForm,
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _memberNameController,
                  decoration: InputDecoration(labelText: 'Member Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the member name';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _skillsController,
                  decoration: InputDecoration(labelText: 'Skills'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the skills';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
