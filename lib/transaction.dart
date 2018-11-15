import 'dart:async';
import 'package:flutter/services.dart';
import 'card.dart';

class Transaction {
  static const _methodChannel = const MethodChannel('paystack_flutter');

  String email;
  int amount;

  Transaction(String email, int amount) {
    this.email = email;
    this.amount = amount;
  }

  Future<String> chargeCard(Card card) async {
    // create map to send to platform method handler
    Map<String, dynamic> args = {
      "email": this.email,
      "amount": this.amount,
      "cardNumber": card.cardNumber,
      "cvc": card.cvc,
      "expiryMonth": card.expiryMonth,
      "expiryYear": card.expiryYear
    };

    return _methodChannel.invokeMethod("chargeCard", args)
      .then<String>((dynamic result) => result);
  }
}