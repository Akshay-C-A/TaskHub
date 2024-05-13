// import 'package:flutter/material.dart';

// class AddTaskPage extends StatefulWidget {
//   const AddTaskPage({super.key});

//   @override
//   State<AddTaskPage> createState() => _AddTaskPageState();
// }

// class _AddTaskPageState extends State<AddTaskPage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   final _formKey = GlobalKey<FormState>();
//   final _detailsController = TextEditingController();
//   final _captionController = TextEditingController();

//   void _resetForm() {
//     _detailsController.clear();
//     _captionController.clear();
//     setState(() {      
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Caption',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextFormField(
//                 controller: _captionController,
//                 validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'This field is required';
//     }
//     return null;
//   },
//                 decoration: const InputDecoration(
//                   hintText: 'Add your caption',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: null,
//               ),
//               const SizedBox(height: 16.0),
//               const Text(
//                 'Details',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextFormField(
//                 controller: _detailsController,
//                 validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'This field is required';
//     }
//     return null;
//   },
//                 decoration: const InputDecoration(
//                   hintText: 'Enter details',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               const Text(
//                 'Photo',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 children: [
//                   IconButton(
//                       onPressed: _pickImage, icon: Icon(Icons.upload_file)),
//                   if (_selectedImage != null)
//                     Expanded(
//                       child: Row(
//                         children: [
//                           const SizedBox(width: 16.0),
//                           Expanded(
//                             child: Image.file(
//                               File(_selectedImage!.path),
//                               height: 200,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: _cancelImageSelection,
//                             icon: const Icon(Icons.cancel),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _submitPost,
//                 child: const Text('Submit'),
//               ),
//               const SizedBox(height: 16.0),
//               IconButton(onPressed: _resetForm, icon: Icon(Icons.delete)),
//             ],
//           ),
//           )
//         ),
//       ),
//     );
//   }
// }