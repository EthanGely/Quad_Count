import 'package:cloud_firestore/cloud_firestore.dart';

class Categorie {
  const Categorie(this.title, this.description);

  final String title;
  final String description;

  factory Categorie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Categorie(
      data['title'] ?? '',
      data['description'] ?? '',
    );
  }
}
