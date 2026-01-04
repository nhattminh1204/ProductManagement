extension PriceFormatter on double {
  /// Format price with thousand separators
  /// Example: 1000000 -> "1.000.000"
  String formatPrice() {
    final price = toInt();
    final priceStr = price.toString();
    final buffer = StringBuffer();
    
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(priceStr[i]);
    }
    
    return buffer.toString();
  }
  
  /// Format price with currency symbol (Vietnamese Dong)
  /// Example: 1000000 -> "1.000.000 đ"
  String formatPriceWithCurrency({String symbol = ' đ'}) {
    return '${formatPrice()}$symbol';
  }
}

