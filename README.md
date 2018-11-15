# Paystack Flutter

This plugin provides an easy way to receive payments on Android and iOS apps with Paystack. It uses the native [Android](https://github.com/PaystackHQ/paystack-android) and [iOS libraries](https://github.com/PaystackHQ/paystack-ios) under the hood and provides a unified API for initializing payment in a platform-agnostic way. The flow surroudning how Paystack payments work is well written in the [Android library documentation](https://github.com/PaystackHQ/paystack-android), so we'll just skip all the formalities and demonstrate how to use this library.

## Usage

### Step 1 - Add this plugin as a dependency to your flutter project

The good folks at [Flutter explains how here](https://flutter.io/platform-plugins/)

### Step 2 - Accept payment

This step assumes you've already built your UI for accepting card details from your application user. And of course, you have your Paystack public API key.

Import the plugin in the file where you want to accept payments.

```
// the plugin exposes a Card class that conflicts with another class of the same name in Flutter's material plugin.
// Importing as PaystackSDK allows you to access the Card class via PaystackSDK.Card
import 'package:paystack_flutter/paystack_flutter.dart' as PaystackSDK;
```

Next, initialize Paystack by proividing your public API key. You should preferably do this once, when the page loads and the public key value will remain set. You can subsequently use the SDK to receive payments multiple times in the page.

```
Future<void> initPaystack() async {
    String paystackKey = "pk_test_xxxxxxxxxxxxxxx";
    try {
        await PaystackSDK.Paystack.initialize(paystackKey);
        // Paystack is ready for use in receiving payments
    } on PlatformException {
        // well, error, deal with it
    }
}
```

Receive payments already!

```
initPayment() {
    // pass card number, cvc, expiry month and year to the Card constructor function
    var card = PaystackSDK.Card("5060666666666666666", "123", 12, 2020);

    // create a transaction with the payer's email and amount (in kobo)
    var transaction = PaystackSDK.Transaction("wisdom.arerosuoghene@gmail.com", 100000);
    
    // debit the card (using Javascript style promises)
    transaction.chargeCard(card)
      .then((transactionReference) {
        // payment successful! You should send your transaction request to your server for validation
      })
      .catchError((e) {
        // oops, payment failed, a readable error message should be in e.message 
      });
}
```
## Contributing

Contributions are most welcome. You could improve this documentation, add method to support more Paystack features or just clean up the code. Just do your thing and create a PR. This started out as a quick work to achieve paystack payments on Android and iOS. A lot could have been done better.