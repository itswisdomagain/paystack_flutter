package tech.itswisdomagain.paystackflutter;

import android.app.Activity;

import java.util.Map;

import co.paystack.android.Paystack;
import co.paystack.android.PaystackSdk;
import co.paystack.android.Transaction;
import co.paystack.android.model.Card;
import co.paystack.android.model.Charge;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** PaystackFlutterPlugin */
public class PaystackFlutterPlugin implements MethodCallHandler {
  private Activity activity;
  private static final String CHARGE_CARD_ERROR_CODE = "chargeCard";
  private static final String INITIALIZE_PAYSTACK_ERROR_CODE = "initializePaystack";

  private PaystackFlutterPlugin(Activity activity) {
    this.activity = activity;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    PaystackFlutterPlugin paystackFlutterPlugin = new PaystackFlutterPlugin(registrar.activity());

    MethodChannel channel = new MethodChannel(registrar.messenger(), "paystack_flutter");
    channel.setMethodCallHandler(paystackFlutterPlugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "initializePaystack":
        this.initializePaystack(call, result);
        break;

      case "chargeCard":
        this.chargeCard(call, result);
        break;

      default:
        result.notImplemented();
    }
  }

  private void initializePaystack(MethodCall call, Result result) {
    if (call.arguments == null) {
      result.error(INITIALIZE_PAYSTACK_ERROR_CODE, "initializePaystack requires paystackKey argument", null);
      return;
    }

    String publicKey = call.arguments();
    PaystackSdk.initialize(this.activity);
    PaystackSdk.setPublicKey(publicKey);
    result.success(null);
  }

  private void chargeCard(MethodCall call, final Result result) {
    // fetch the required card and transaction information from call.argument map
    if (call.arguments == null || !(call.arguments instanceof Map)) {
      result.error(CHARGE_CARD_ERROR_CODE, "chargeCard requires card and transaction information", null);
      return;
    }

    String email = call.argument("email");
    Integer amount = call.argument("amount");
    String cardNumber = call.argument("cardNumber");
    String cvc = call.argument("cvc");
    Integer expiryMonth = call.argument("expiryMonth");
    Integer expiryYear = call.argument("expiryYear");

    if (email == null || amount == null || cardNumber == null || cvc == null || expiryMonth == null || expiryYear == null) {
      result.error(CHARGE_CARD_ERROR_CODE, "1 or more required card/transaction information not provided", null);
      return;
    }

    Card card = new Card(cardNumber, expiryMonth, expiryYear, cvc);
    if (!card.isValid()) {
      result.error(CHARGE_CARD_ERROR_CODE, "card information is incorrect or invalid", null);
      return;
    }

    Charge charge = new Charge();
    charge.setCard(card);
    charge.setAmount(amount);
    charge.setEmail(email);

    PaystackSdk.chargeCard(this.activity, charge, new Paystack.TransactionCallback() {
      @Override
      public void onSuccess(Transaction transaction) {
        result.success(transaction.getReference());
      }

      @Override
      public void beforeValidate(Transaction transaction) {
        // todo, use a stream (?) to keep user updated for this kind of scenario
        // but remember the process still continues until onSuccess or onError is called
      }

      @Override
      public void onError(Throwable error, Transaction transaction) {
        result.error(CHARGE_CARD_ERROR_CODE, error.getLocalizedMessage(), transaction.getReference());
      }
    });
  }
}
