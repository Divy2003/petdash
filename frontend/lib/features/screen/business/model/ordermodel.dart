class OrderModel {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final String status;

  OrderModel({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.status,
  });
}