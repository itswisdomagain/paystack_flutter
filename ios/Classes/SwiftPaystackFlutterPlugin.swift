import Flutter
import UIKit
import Paystack

public class SwiftPaystackFlutterPlugin: NSObject, FlutterPlugin {
    private static var CHARGE_CARD_ERROR_CODE = "chargeCard"
    private static var INITIALIZE_PAYSTACK_ERROR_CODE = "initializePaystack"
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paystack_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftPaystackFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initializePaystack":
        self.initializePaystack(call, result)
        
    case "chargeCard":
        self.chargeCard(call, result)
        
    default:
        result(FlutterError(code: "UNKNOWN METHOND",
                            message: "Request not understood",
                            details: nil))
    }   
  }
    
    private func initializePaystack(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if call.arguments == nil {
            result(FlutterError(code: SwiftPaystackFlutterPlugin.INITIALIZE_PAYSTACK_ERROR_CODE,
                                message: "initializePaystack requires paystackKey argument",
                                details: nil))
            return
        }
        
        let publicKey = call.arguments as! String
        Paystack.setDefaultPublicKey(publicKey)
        result(nil)
    }
    
    private func chargeCard(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if call.arguments == nil || !(call.arguments is NSDictionary) {
            result(FlutterError(code: SwiftPaystackFlutterPlugin.CHARGE_CARD_ERROR_CODE,
                                message: "chargeCard requires card and transaction information",
                                details: nil))
            return
        }
        
        let cardAndTransactionDictionary = call.arguments as! NSDictionary
        let email = cardAndTransactionDictionary.value(forKey: "email") as? String
        let amount = cardAndTransactionDictionary.value(forKey: "amount") as? Int
        let cardNumber = cardAndTransactionDictionary.value(forKey: "cardNumber") as? String
        let cvc = cardAndTransactionDictionary.value(forKey: "cvc") as? String
        let expiryMonth = cardAndTransactionDictionary.value(forKey: "expiryMonth") as? Int
        let expiryYear = cardAndTransactionDictionary.value(forKey: "expiryYear") as? Int
        
        if email == nil || amount == nil || cardNumber == nil || cvc == nil || expiryMonth == nil || expiryYear == nil {
            result(FlutterError(code: SwiftPaystackFlutterPlugin.CHARGE_CARD_ERROR_CODE,
                                message: "1 or more required card/transaction information not provided",
                                details: nil))
            return
        }
        
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        if viewController == nil {
            result(FlutterError(code: SwiftPaystackFlutterPlugin.CHARGE_CARD_ERROR_CODE,
                                message: "Paystack payments can only be initialized from a View Controller",
                                details: nil))
            return
        }
        
        let cardParams = PSTCKCardParams.init();
        cardParams.number = cardNumber!
        cardParams.cvc = cvc!
        cardParams.expYear = UInt(expiryYear!)
        cardParams.expMonth = UInt(expiryMonth!)
        
        let transactionParams = PSTCKTransactionParams.init();
        transactionParams.amount = UInt(amount!)
        transactionParams.email = email!
        
        func errorHandler(error: Error, reference: String?) -> Void {
            result(FlutterError(code: SwiftPaystackFlutterPlugin.CHARGE_CARD_ERROR_CODE,
                                message: error.localizedDescription,
                                details: reference))
        }
        func validationRequestedHandler(reference: String) -> Void {
            // todo, use a stream (?) to keep user updated for this kind of scenario
            // but remember the process still continues until onSuccess or onError is called
        }
        func successHandler(reference: String) -> Void {
            result(reference)
        }
        
        PSTCKAPIClient.shared().chargeCard(cardParams, forTransaction: transactionParams, on: viewController!,
                                           didEndWithError: errorHandler,
                                           didRequestValidation: validationRequestedHandler,
                                           didTransactionSuccess: successHandler)
    }
}
