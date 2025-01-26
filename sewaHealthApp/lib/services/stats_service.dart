
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String,dynamic>>getStats() async {
    return await _firestore.collection("stats").doc("summary").get()
        .then((DocumentSnapshot snapshot) => snapshot.data() as Map<String,dynamic>);
  }
}