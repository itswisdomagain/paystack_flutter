import 'card.dart';

class Transaction {
  String email;
  double amount;

  Transaction(String email, double amount) {
    this.email = email;
    this.amount = amount;
  }

  Future<String> charge(Card card) async {
    return "";
  }
}