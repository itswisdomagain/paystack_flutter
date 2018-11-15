class Card {
  String cardNumber;
  String cvc;
  int expiryMonth;
  int expiryYear;

  Card(String cardNumber, String cvc, int expiryMonth, int expiryYear) {
    this.cardNumber = cardNumber;
    this.cvc = cvc;
    this.expiryMonth = expiryMonth;
    this.expiryYear = expiryYear;
  }

  bool isValid() {
    // todo: invoke platform specific implementation or run check here
    return true;
  }
}