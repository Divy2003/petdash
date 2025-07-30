class CardModel {
  String id;
  String name;
  String last4;
  String exp;
  String brand;

  CardModel({
    required this.id,
    required this.name,
    required this.last4,
    required this.exp,
    required this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'last4': last4,
      'exp': exp,
      'brand': brand,
    };
  }

  factory CardModel.fromMap(String id, Map<String, dynamic> map) {
    return CardModel(
      id: id,
      name: map['name'],
      last4: map['last4'],
      exp: map['exp'],
      brand: map['brand'],
    );
  }
}
