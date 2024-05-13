// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:taskhubapp/TeamMember/member_profile_form.dart';

// class ProfileScreen extends StatefulWidget {
//   final Member member;

//   ProfileScreen({required this.member});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.member.memberName),
//           actions: [
//             // TextButton(
//             //   // onPressed: () async {
//             //   //   try {
//             //   //     await FirebaseAuth.instance.signOut();
//             //   //     Navigator.pushAndRemoveUntil(
//             //   //       context,
//             //   //       MaterialPageRoute(builder: (context) => MainPage()),
//             //   //       (route) => false,
//             //   //     );
//             //   //   } catch (e) {
//             //   //     print('Error signing out: $e');
//             //   //   }
//             //   // },
//             //   // child: Text('LogOut'),
//             // )
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: height * .13),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(width * .08, 0, width * .08, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 110,
//                       height: 110,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(35),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(28),
//                           child: Image.network(widget.member.dpURL,
//                               fit: BoxFit.cover),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: width * .05),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Wrap(
//                             alignment: WrapAlignment.center,
//                             children: [
//                               Text(
//                                 widget.member.memberName,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 30,
//                                 ),
//                                 textAlign: TextAlign.start,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Text(widget.member.teamName),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MemberProfileForm(),
//                           ),
//                         );
//                       },
//                       icon: Icon(Icons.edit),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Email',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           widget.member.email,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Department',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           widget.member.department,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(width * .08, width * 0.03, width * .08, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.member.bio,
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: width * 0.08),
//                     Column(
//                       children: [
//                         Text(
//                           'Skills',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Wrap(
//                           spacing: 8.0,
//                           runSpacing: 8.0,
//                           children: widget.member.skills
//                               .map((skill) => Chip(
//                                     label: Text(skill),
//                                   ))
//                               .toList(),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
