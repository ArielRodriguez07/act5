import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blondgames_entry.dart'; // Importa el nuevo modelo

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _entriesCollection;

  FirestoreService() {
    // La colección se llamará 'blondgames_entries'
    _entriesCollection = _db.collection('blondgames_entries');
  }

  Future<void> addEntry(BlondGamesEntry entry) async {
    await _entriesCollection.add(entry.toFirestore());
  }

  Stream<List<BlondGamesEntry>> getEntries() {
    return _entriesCollection.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BlondGamesEntry.fromFirestore(doc)).toList();
    });
  }

  Stream<List<BlondGamesEntry>> getGames() {
    return _entriesCollection
        .where('type', isEqualTo: 'game')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BlondGamesEntry.fromFirestore(doc)).toList();
    });
  }

  Stream<List<BlondGamesEntry>> getFAQs() {
    return _entriesCollection
        .where('type', isEqualTo: 'faq')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BlondGamesEntry.fromFirestore(doc)).toList();
    });
  }

  Future<void> deleteEntry(String id) async {
    await _entriesCollection.doc(id).delete();
  }
}