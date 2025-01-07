import './categorie/categorie.dart';
import './categorie/payement.dart';
import './categorie/user.dart';

final List<Categorie> mockCategories = const [
  Categorie('Barbecue', 'Ribs & beers'),
  Categorie('Ski', 'You break, you lose'),
  Categorie('Raclette', 'Jusqu\'au bout de la nuit'),
];

final List<User> mockUsers = [
  User('Alex', [mockCategories[0]]),
  User('Bruno', [mockCategories[0]]),
  User('Julia', [mockCategories[0]]),
  User('Loïc', [mockCategories[0]]),
  User('Thomas', [mockCategories[0]]),
];

final List<Payement> mockPayements = [
  Payement(64, mockUsers[2], 'Voiture', mockCategories[0]),
  Payement(13, mockUsers[1], 'Picnic', mockCategories[0]),
  //Payement(25.0, mockUsers[0], 'LSD', mockCategories[1]),
  Payement(102, mockUsers[0], 'Hôtel', mockCategories[0]),
];
