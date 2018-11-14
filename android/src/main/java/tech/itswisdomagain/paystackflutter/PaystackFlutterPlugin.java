package tech.itswisdomagain.paystackflutter;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** PaystackFlutterPlugin */
public class PaystackFlutterPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "paystack_flutter");
    channel.setMethodCallHandler(new PaystackFlutterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "initializePaystack":
        this.initializePaystack(call.arguments.toString());
        break;
    }
    if (call.method.equals("initializePaystack")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  private void initializePaystack(String paystackKey) {

  }

  private void chargeCard(HashMap<String, Object> cardObj, HashMap<String, Object> transactionObj) {

  }
}
