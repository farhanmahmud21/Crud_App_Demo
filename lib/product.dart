class Product {
  final String id, productName, img;
  final int productCode, qty, unitPrice, totalPrice;

  Product(this.id, this.productName, this.productCode, this.img, this.qty,
      this.unitPrice, this.totalPrice);

  factory Product.toJson(Map<String, dynamic> x) {
    return Product(x["_id"], x["ProductName"], x["ProductCode"], x["Img"],
        x["Qty"], x["UnitPrice"], x["TotalPrice"]);
  }
}
