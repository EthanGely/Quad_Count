import 'package:flutter/material.dart';
import 'package:quad_count/src/categorie/categorie.dart';
import 'package:quad_count/src/categorie/categorie_detail_view.dart';
import 'package:quad_count/src/categorie/payement.dart';
import 'package:quad_count/src/categorie/user.dart';

/// Displays detailed information about a SampleItem.
class CategoriePayementDetailsView extends StatelessWidget {
  const CategoriePayementDetailsView(
      {super.key,
      required this.categorie,
      required this.payements,
      required this.users});

  static const routeName = '/remboursements';
  final Categorie categorie;

  final List<Payement> payements;

  final List<User> users;

  // LETS MATH !!!!
  double total() {
    return payements
        .where((payement) => payement.categorie.title == categorie.title)
        .map((payement) => payement.value)
        .fold(0.0, (a, b) => a + b);
  }

  double average() {
    return total() / users.length;
  }

  //Calculate who owes who
  Map<String, double> calculateDebts() {
    final debts = <String, double>{};

    for (var user in users) {
      final userPayements = payements
          .where((payement) => payement.user == user)
          .map((payement) => payement.value)
          .fold(0.0, (a, b) => a + b);
      final debt = (userPayements - average()).toDouble();
      debts[user.name] = debt;
    }

    return debts;
  }


  List<Map<String, dynamic>> calculateTransactions() {
    final debts = calculateDebts();
    final transactions = <Map<String, dynamic>>[];

    while (debts.values.any((debt) => debt.abs() > 0.01)) {
      final maxCreditor = debts.entries.reduce((a, b) => a.value > b.value ? a : b);
      final maxDebtor = debts.entries.reduce((a, b) => a.value < b.value ? a : b);

      final amount = maxCreditor.value.abs() < maxDebtor.value.abs()
          ? maxCreditor.value
          : -maxDebtor.value;

      transactions.add({
        'from': maxDebtor.key,
        'to': maxCreditor.key,
        'amount': amount,
      });

      debts[maxCreditor.key] = (debts[maxCreditor.key] ?? 0) - amount;
      debts[maxDebtor.key] = (debts[maxDebtor.key] ?? 0) + amount;
    }

    return transactions;
  }

  // Given a user, calculate who it owes to
  User owesTo(User user) {
    final debts = calculateDebts();
    return users.where((u) => u != user).reduce((a, b) =>
        debts[a.name]! < debts[b.name]! ? a : b);
  }

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorieDetailsView(
                        categorie: categorie,
                        payements: payements,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurple[300], backgroundColor: Colors.grey[900],
                ),
                child: Text('Dépenses'),
              ),
                ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple[500],
                ),
                child: Text('Remboursements'),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if (average() <
                    payements
                        .where((payement) => payement.user == user)
                        .map((payement) => payement.value)
                        .fold(0.0, (a, b) => a + b)) {
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(
                        '+ ${calculateDebts()[user.name]!.toStringAsFixed(2)}€'),
                    textColor: Colors.green,
                    trailing: Icon(Icons.attach_money),
                  onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                    final userTransactions = calculateTransactions()
                      .where((transaction) => transaction['from'] == user.name || transaction['to'] == user.name)
                      .toList();
                    return ListView.builder(
                      itemCount: userTransactions.length,
                      itemBuilder: (context, index) {
                      final transaction = userTransactions[index];
                      return ListTile(
                        title: Text(
                        transaction['from'] == user.name
                          ? 'Doit ${transaction['amount'].toStringAsFixed(2)}€ à ${transaction['to']}'
                          : 'Reçoit ${transaction['amount'].toStringAsFixed(2)}€ de ${transaction['from']}',
                        ),
                      );
                      },
                    );
                    },
                  );
                  },
                  );
                }
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(
                      '${calculateDebts()[user.name]!.toStringAsFixed(2)}€'),
                  textColor: Colors.red,
                    trailing: Icon(Icons.money_off),
                  onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                    final userTransactions = calculateTransactions()
                      .where((transaction) => transaction['from'] == user.name || transaction['to'] == user.name)
                      .toList();
                    return ListView.builder(
                      itemCount: userTransactions.length,
                      itemBuilder: (context, index) {
                      final transaction = userTransactions[index];
                      return ListTile(
                        title: Text(
                        transaction['from'] == user.name
                          ? 'Doit ${transaction['amount'].toStringAsFixed(2)}€ à ${transaction['to']}'
                          : 'Reçoit ${transaction['amount'].toStringAsFixed(2)}€ de ${transaction['from']}',
                        ),
                      );
                      },
                    );
                    },
                  );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
