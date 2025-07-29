class ServiceModel {
  final String id;
  final String businessId;
  final String categoryId;
  final String title;
  final String? description;
  final String? serviceIncluded;
  final String? notes;
  final String? price;
  final List<String> images;
  final ServiceAvailability availableFor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryInfo? category;

  ServiceModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.title,
    this.description,
    this.serviceIncluded,
    this.notes,
    this.price,
    required this.images,
    required this.availableFor,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      businessId: json['business'] ?? '',
      categoryId: json['category'] is String ? json['category'] : json['category']?['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      serviceIncluded: json['serviceIncluded'],
      notes: json['notes'],
      price: json['price'],
      images: List<String>.from(json['images'] ?? []),
      availableFor: ServiceAvailability.fromJson(json['availableFor'] ?? {}),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      category: json['category'] is Map<String, dynamic> 
          ? CategoryInfo.fromJson(json['category']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'business': businessId,
      'category': categoryId,
      'title': title,
      'description': description,
      'serviceIncluded': serviceIncluded,
      'notes': notes,
      'price': price,
      'images': images,
      'availableFor': availableFor.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to create a copy with updated fields
  ServiceModel copyWith({
    String? id,
    String? businessId,
    String? categoryId,
    String? title,
    String? description,
    String? serviceIncluded,
    String? notes,
    String? price,
    List<String>? images,
    ServiceAvailability? availableFor,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryInfo? category,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      serviceIncluded: serviceIncluded ?? this.serviceIncluded,
      notes: notes ?? this.notes,
      price: price ?? this.price,
      images: images ?? this.images,
      availableFor: availableFor ?? this.availableFor,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }
}

class ServiceAvailability {
  final List<String> cats;
  final List<String> dogs;

  ServiceAvailability({
    required this.cats,
    required this.dogs,
  });

  factory ServiceAvailability.fromJson(Map<String, dynamic> json) {
    return ServiceAvailability(
      cats: List<String>.from(json['cats'] ?? []),
      dogs: List<String>.from(json['dogs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cats': cats,
      'dogs': dogs,
    };
  }

  ServiceAvailability copyWith({
    List<String>? cats,
    List<String>? dogs,
  }) {
    return ServiceAvailability(
      cats: cats ?? this.cats,
      dogs: dogs ?? this.dogs,
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;

  CategoryInfo({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

// Request model for creating/updating services
class ServiceRequest {
  final String categoryId;
  final String title;
  final String? description;
  final String? serviceIncluded;
  final String? notes;
  final String? price;
  final ServiceAvailability availableFor;
  final List<String>? imagePaths; // For file uploads

  ServiceRequest({
    required this.categoryId,
    required this.title,
    this.description,
    this.serviceIncluded,
    this.notes,
    this.price,
    required this.availableFor,
    this.imagePaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'title': title,
      'description': description,
      'serviceIncluded': serviceIncluded,
      'notes': notes,
      'price': price,
      'availableFor': availableFor.toJson(),
    };
  }
}
