import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:paystack_flutter/paystack_flutter.dart' as PaystackSDK;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _paymentReady = false;

  @override
  void initState() {
    super.initState();
    initPaystack();
  }

  // Platform messages may fail, so we use a try/catch PlatformException.
  Future<void> initPaystack() async {
    displayMessage("Initializing Paystack");
    
    String paystackKey = "pk_test_xxxxxxxxxxxxxxx";
    try {
      await PaystackSDK.Paystack.initialize(paystackKey);
      _paymentReady = true;
      displayMessage("Paystack Initialized. Ready to receive payment");
    } on PlatformException {
      displayError("Error intializing Paystack key to $paystackKey");
    }
  }

  initPayment() {
    if (!_paymentReady) {
      return;
    }

    displayMessage("Starting transaction...");
    _paymentReady = false;

    /*
    Test OTP Card from Paystack
    50606 66666 66666 6666
    CVV: 123
    PIN: 1234
    TOKEN: 123456
    EXPIRY: any date in the future
    */
    var card = PaystackSDK.Card("5060666666666666666", "123", 12, 2020);
    var transaction = PaystackSDK.Transaction("wisdom.arerosuoghene@gmail.com", 100000); // amount in kobo
    
    transaction.chargeCard(card)
      .then((transactionReference) {
        displayMessage("Transaction complete\nReference: $transactionReference");
        _paymentReady = true;
      })
      .catchError((e) {
        displayError(e.message);
        _paymentReady = true;
      });
  }

  displayMessage(String message) {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = message;
    });
  }

  displayError(String error) {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = 'Error:\n$error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paystack Flutter SDK Sample'),
        ),
        body: Center(
          child: Text(_platformVersion),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPayment,
          tooltip: 'Init Payment',
          child: Icon(Icons.payment),
        ),
      ),
    );
  }
}
