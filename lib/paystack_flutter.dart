import 'dart:async';
import 'package:flutter/services.dart';

export 'card.dart';
export 'transaction.dart';

class Paystack {
  static const _methodChannel = const MethodChannel('paystack_flutter');

  static Future<String> initialize(String paystackKey) async {
    return _methodChannel.invokeMethod('initializePaystack', paystackKey);
  }
}
