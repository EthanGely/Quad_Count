import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'categorie_detail_view.dart';
import 'categorie.dart';

class CategorieListView extends StatelessWidget {
  CategorieListView({super.key});

  static const routeName = '/';

  Future<List<Categorie>> fetchCategories() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('categorie').get();
    return querySnapshot.docs.map((doc) => Categorie.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quad Count'),
      ),
      body: FutureBuilder<List<Categorie>>(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              restorationId: 'categorieListView',
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final item = categories[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategorieDetailsView(categorie: item, payements: []),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}