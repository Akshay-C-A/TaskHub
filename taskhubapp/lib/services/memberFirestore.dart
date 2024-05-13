import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference memberCollection =
    FirebaseFirestore.instance.collection('members');

class MemberFirestore {
  static Future<DocumentSnapshot> getMember({
    required String memberId,
  }) async {
    try {
      return await memberCollection.doc(memberId).get();
    } catch (e) {
      print('Error getting member details: $e');
      throw Exception('Failed to get member details: $e');
    }
  }

  // Add other functions as needed
}
