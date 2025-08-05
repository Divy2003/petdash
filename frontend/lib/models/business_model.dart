import '../utlis/app_config/app_config.dart';

class BusinessModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? description;
  final String? profileImage;
  final String? shopImage;
  final BusinessAddress? address;
  final List<String> categories;
  final double? rating;
  final int? reviewCount;
  final BusinessHours? businessHours;
  final bool isActive;
  final DateTime createdAt;

  BusinessModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.description,
    this.profileImage,
    this.shopImage,
    this.address,
    required this.categories,
    this.rating,
    this.reviewCount,
    this.businessHours,
    required this.isActive,
    required this.createdAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    // Handle profile image
    String? profileImagePath = json['profileImage'];
    String? fullProfileImageUrl;

    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      if (profileImagePath.startsWith('http')) {
        fullProfileImageUrl = profileImagePath;
      } else {
        String cleanPath = profileImagePath.startsWith('/')
            ? profileImagePath.substring(1)
            : profileImagePath;
        fullProfileImageUrl = '${AppConfig.baseFileUrl}/$cleanPath';
      }
    }

    // Handle shop image (for logo)
    String? shopImagePath = json['shopImage'];
    String? fullShopImageUrl;

    if (shopImagePath != null && shopImagePath.isNotEmpty) {
      if (shopImagePath.startsWith('http')) {
        fullShopImageUrl = shopImagePath;
      } else {
        String cleanPath = shopImagePath.startsWith('/')
            ? shopImagePath.substring(1)
            : shopImagePath;
        fullShopImageUrl = '${AppConfig.baseFileUrl}/$cleanPath';
      }
    }

    // Handle business hours from API format
    BusinessHours? businessHours;
    if (json['shopOpenTime'] != null && json['shopCloseTime'] != null) {
      // Create a simple business hours object from shop times
      Map<String, DayHours> hoursMap = {};

      // Assume the shop is open Monday to Friday with the given times
      List<String> weekdays = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday'
      ];
      for (String day in weekdays) {
        hoursMap[day] = DayHours(
          isOpen: true,
          openTime: json['shopOpenTime'],
          closeTime: json['shopCloseTime'],
        );
      }

      // Weekend closed
      hoursMap['saturday'] = DayHours(isOpen: false);
      hoursMap['sunday'] = DayHours(isOpen: false);

      businessHours = BusinessHours(hours: hoursMap);
    } else if (json['businessHours'] != null) {
      businessHours = BusinessHours.fromJson(json['businessHours']);
    }

    // Handle address from different possible formats
    BusinessAddress? address;
    if (json['address'] != null) {
      address = BusinessAddress.fromJson(json['address']);
    } else if (json['addresses'] != null &&
        json['addresses'] is List &&
        (json['addresses'] as List).isNotEmpty) {
      // Use the primary address or first address
      List<dynamic> addresses = json['addresses'];
      Map<String, dynamic>? primaryAddress = addresses.firstWhere(
        (addr) => addr['isPrimary'] == true,
        orElse: () => addresses.first,
      );
      if (primaryAddress != null) {
        address = BusinessAddress(
          street: primaryAddress['streetName'] ?? '',
          city: primaryAddress['city'] ?? '',
          state: primaryAddress['state'] ?? '',
          zipCode: primaryAddress['zipCode'] ?? '',
          country: primaryAddress['country'],
        );
      }
    } else if (json['formattedAddress'] != null) {
      // Parse formatted address if available
      String formattedAddr = json['formattedAddress'];
      List<String> parts = formattedAddr.split(', ');
      address = BusinessAddress(
        street: parts.isNotEmpty ? parts[0] : '',
        city: parts.length > 1 ? parts[1] : '',
        state: parts.length > 2 ? parts[2] : '',
        zipCode: '',
      );
    }

    return BusinessModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'],
      description: json['description'],
      profileImage: fullProfileImageUrl,
      shopImage: fullShopImageUrl,
      address: address,
      categories: List<String>.from(json['categories'] ?? []),
      rating: (json['rating'] ?? json['averageRating'])?.toDouble(),
      reviewCount: (json['reviewCount'] ?? json['totalReviews'])?.toInt(),
      businessHours: businessHours,
      isActive: json['isActive'] ?? true,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'description': description,
      'profileImage': profileImage,
      'shopImage': shopImage,
      'address': address?.toJson(),
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'businessHours': businessHours?.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper method to get distance display
  String get distanceDisplay {
    // This would be calculated based on user location
    // For now, return a placeholder
    return '${(rating ?? 0.0).toStringAsFixed(1)} miles away';
  }

  // Helper method to get rating display
  String get ratingDisplay {
    return rating?.toStringAsFixed(1) ?? '0.0';
  }

  // Helper method to get open status
  String get openStatus {
    if (businessHours != null) {
      return businessHours!.getCurrentStatus();
    }
    return 'Hours not available';
  }
}

class BusinessAddress {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String? country;

  BusinessAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country,
  });

  factory BusinessAddress.fromJson(Map<String, dynamic> json) {
    return BusinessAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  String get fullAddress {
    return '$street, $city, $state $zipCode';
  }
}

class BusinessHours {
  final Map<String, DayHours> hours;

  BusinessHours({required this.hours});

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    Map<String, DayHours> hoursMap = {};
    json.forEach((key, value) {
      if (value != null) {
        hoursMap[key] = DayHours.fromJson(value);
      }
    });
    return BusinessHours(hours: hoursMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    hours.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }

  String getCurrentStatus() {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final dayHours = hours[dayName];

    if (dayHours == null || !dayHours.isOpen) {
      return 'Closed';
    }

    return 'Open ${dayHours.openTime}–${dayHours.closeTime}';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'monday';
    }
  }
}

class DayHours {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) {
    return DayHours(
      isOpen: json['isOpen'] ?? false,
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
