import 'package:flutter/material.dart';
import 'package:quad_count/src/categorie/categorie.dart';
import 'package:quad_count/src/categorie/categorie_payement_detail_view.dart';
import 'package:quad_count/src/categorie/payement.dart';
import '../mock_data.dart';

/// Displays detailed information about a SampleItem.
class CategorieDetailsView extends StatelessWidget {
  const CategorieDetailsView({
    super.key,
    required this.categorie,
    required this.payements,
  });

  factory CategorieDetailsView.withMockData(Categorie categorie) {
    return CategorieDetailsView(
      categorie: categorie,
      payements: mockPayements,
    );
  }

  static const routeName = '/categorie_details';
  final Categorie categorie;

  final List<Payement> payements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categorie.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.settings.name == '/');
          },
        ),
      ),
      body: Column(
        children: [
          Text(
            categorie.description,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            'Total: ${payements.where((payement) => payement.categorie.title == categorie.title).map((payement) => payement.value).fold(0.0, (a, b) => a + b).toStringAsFixed(2)}€',
            style: TextStyle(fontSize: 17.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple[500],
                ),
                child: Text('Dépenses'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriePayementDetailsView(
                        categorie: categorie,
                        payements: mockPayements,
                        users: mockUsers,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepPurple[300],
                  backgroundColor: Colors.grey[900],
                ),
                child: Text('Remboursements'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: payements.length,
              itemBuilder: (context, index) {
                final payement = payements[index];
                if (payement.categorie.title == categorie.title) {
                  return ListTile(
                    title: Text(payement.title),
                    subtitle: Text(
                        '${payement.user.name} - ${payement.value.toStringAsFixed(2)}€'),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
