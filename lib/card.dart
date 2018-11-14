class Card {
  String cardNumber;
  String cvv;
  int expiryMonth;
  int expiryYear;

/*
public static final String VISA = "Visa";
        public static final String MASTERCARD = "MasterCard";
        public static final String AMERICAN_EXPRESS = "American Express";
        public static final String DINERS_CLUB = "Diners Club";
        public static final String DISCOVER = "Discover";
        public static final String JCB = "JCB";
        public static final String VERVE = "VERVE";
        public static final String UNKNOWN = "Unknown";
        //lengths for some cards
        public static final int MAX_LENGTH_NORMAL = 16;
        public static final int MAX_LENGTH_AMERICAN_EXPRESS = 15;
        public static final int MAX_LENGTH_DINERS_CLUB = 14;
        //source of these regex patterns http://stackoverflow.com/questions/72768/how-do-you-detect-credit-card-type-based-on-number
        public static final String PATTERN_VISA = "^4[0-9]{12}(?:[0-9]{3})?$";
        public static final String PATTERN_MASTERCARD = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$";
        public static final String PATTERN_AMERICAN_EXPRESS = "^3[47][0-9]{13}$";
        public static final String PATTERN_DINERS_CLUB = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
        public static final String PATTERN_DISCOVER = "^6(?:011|5[0-9]{2})[0-9]{12}$";
        public static final String PATTERN_JCB = "^(?:2131|1800|35[0-9]{3})[0-9]{11}$";
        public static final String PATTERN_VERVE = "^((506(0|1))|(507(8|9))|(6500))[0-9]{12,15}$";
*/

  final _cardTypes = [
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
    new CardType('Visa', new RegExp(r'')),
  ];

  Card(String cardNumber, String cvv, int expiryMonth, int expiryYear) {
    this.cardNumber = cardNumber;
    this.cvv = cvv;
    this.expiryMonth = expiryMonth;
    this.expiryYear = expiryYear;
  }

  String getType() {
    // for ()
    return "Unrecognized";
  }

  bool isValid() {
    // todo: invoke platform specific implementation or run check here
    return true;
  }
}

class CardType {
  String name;
  RegExp cardNumberPattern;

  CardType(String name, RegExp cardNumberPattern) {
    this.name = name;
    this.cardNumberPattern = cardNumberPattern;
  }
}