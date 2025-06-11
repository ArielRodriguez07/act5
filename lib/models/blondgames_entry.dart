import 'package:cloud_firestore/cloud_firestore.dart';

enum EntryType { game, faq }

class BlondGamesEntry {
  String? id;
  final String title;
  final String content; // Puede ser descripción del juego o respuesta de FAQ
  final Timestamp timestamp;
  final EntryType type; // Nuevo campo para diferenciar entre juego y FAQ
  final String? genre;    // Solo para juegos
  final String? platform; // Solo para juegos

  BlondGamesEntry({
    this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.type,
    this.genre,
    this.platform,
  });

  factory BlondGamesEntry.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BlondGamesEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      type: (data['type'] == 'game') ? EntryType.game : EntryType.faq,
      genre: data['genre'],
      platform: data['platform'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'type': type == EntryType.game ? 'game' : 'faq',
      'genre': genre,
      'platform': platform,
    };
  }
}