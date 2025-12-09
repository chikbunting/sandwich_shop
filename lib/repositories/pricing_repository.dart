class PricingRepository {
  final double sixInchPrice;
  final double footlongPrice;

  PricingRepository({required this.sixInchPrice, required this.footlongPrice});

  /// Returns the unit price for the selected sandwich size.
  double unitPrice({required bool isFootlong}) => isFootlong ? footlongPrice : sixInchPrice;

  /// Calculates the total price for [quantity] sandwiches of the given size.
  double totalFor({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    return unitPrice(isFootlong: isFootlong) * quantity;
  }

  /// Backwards-compatible helper used in some places as `calculatePrice`.
  double calculatePrice({required int quantity, required bool isFootlong}) {
    return totalFor(quantity: quantity, isFootlong: isFootlong);
  }
}
