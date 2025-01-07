import 'package:quad_count/src/categorie/categorie.dart';
import 'package:quad_count/src/categorie/user.dart';

/// A placeholder class that represents an entity or model.
class Payement {
  const Payement(this.value, this.user, this.title, this.categorie);
  final double value;
  final User user;
  final String title;
  final Categorie categorie;
}
