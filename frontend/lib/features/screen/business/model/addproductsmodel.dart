class ProductRequest {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String manufacturer;
  final double shippingCost;
  final double? monthlyDeliveryPrice;
  final String brand;
  final String itemWeight;
  final String itemForm;
  final String ageRange;
  final String breedRecommendation;
  final String dietType;
  final List<String> images;
  final int stock;
  final bool subscriptionAvailable;
  final String category;

  ProductRequest({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.manufacturer,
    required this.shippingCost,
    this.monthlyDeliveryPrice,
    required this.brand,
    required this.itemWeight,
    required this.itemForm,
    required this.ageRange,
    required this.breedRecommendation,
    required this.dietType,
    required this.images,
    required this.stock,
    required this.subscriptionAvailable,
    required this.category,
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) {
    return ProductRequest(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      manufacturer: json['manufacturer'] ?? '',
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      monthlyDeliveryPrice: json['monthlyDeliveryPrice'] != null
          ? (json['monthlyDeliveryPrice'] as num).toDouble()
          : null,
      brand: json['brand'] ?? '',
      itemWeight: json['itemWeight'] ?? '',
      itemForm: json['itemForm'] ?? '',
      ageRange: json['ageRange'] ?? '',
      breedRecommendation: json['breedRecommendation'] ?? '',
      dietType: json['dietType'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] ?? 0,
      subscriptionAvailable: json['subscriptionAvailable'] ?? false,
      category: json['category'] ?? '',
    );
  }


  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "manufacturer": manufacturer,
    "shippingCost": shippingCost,
    "monthlyDeliveryPrice": monthlyDeliveryPrice ?? 0,
    "brand": brand,
    "itemWeight": itemWeight,
    "itemForm": itemForm,
    "ageRange": ageRange,
    "breedRecommendation": breedRecommendation,
    "dietType": dietType,
    "images": images,
    "stock": stock,
    "subscriptionAvailable": subscriptionAvailable,
    "category": category,
  };
}
