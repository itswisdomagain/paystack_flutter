class Card {
  String cardNumber;
  String cvv;
  int expiryMonth;
  int expiryYear;

  Card(String cardNumber, String cvv, int expiryMonth, int expiryYear) {
    this.cardNumber = cardNumber;
    this.cvv = cvv;
    this.expiryMonth = expiryMonth;
    this.expiryYear = expiryYear;
  }

  bool isValid() {
    // todo: invoke platform specific implementation or run check here
    return true;
  }
}