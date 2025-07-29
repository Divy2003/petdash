class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;
  final String? userType;
  final String? currentRole;
  final List<String>? availableRoles;
  final bool? canSwitchRoles;
  final AddressModel? primaryAddress;
  final List<AddressModel>? addresses;
  
  // Business-specific fields
  final String? shopImage;
  final String? shopOpenTime;
  final String? shopCloseTime;
  
  // Role-specific data
  final RoleSpecificData? roleSpecificData;
  
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.userType,
    this.currentRole,
    this.availableRoles,
    this.canSwitchRoles,
    this.primaryAddress,
    this.addresses,
    this.shopImage,
    this.shopOpenTime,
    this.shopCloseTime,
    this.roleSpecificData,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      userType: json['userType'],
      currentRole: json['currentRole'],
      availableRoles: json['availableRoles'] != null 
          ? List<String>.from(json['availableRoles'])
          : null,
      canSwitchRoles: json['canSwitchRoles'],
      primaryAddress: json['primaryAddress'] != null 
          ? AddressModel.fromJson(json['primaryAddress'])
          : null,
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
              .map((address) => AddressModel.fromJson(address))
              .toList()
          : null,
      shopImage: json['shopImage'],
      shopOpenTime: json['shopOpenTime'],
      shopCloseTime: json['shopCloseTime'],
      roleSpecificData: json['roleSpecificData'] != null
          ? RoleSpecificData.fromJson(json['roleSpecificData'])
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'userType': userType,
      'currentRole': currentRole,
      'availableRoles': availableRoles,
      'canSwitchRoles': canSwitchRoles,
      'primaryAddress': primaryAddress?.toJson(),
      'addresses': addresses?.map((address) => address.toJson()).toList(),
      'shopImage': shopImage,
      'shopOpenTime': shopOpenTime,
      'shopCloseTime': shopCloseTime,
      'roleSpecificData': roleSpecificData?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? userType,
    String? currentRole,
    List<String>? availableRoles,
    bool? canSwitchRoles,
    AddressModel? primaryAddress,
    List<AddressModel>? addresses,
    String? shopImage,
    String? shopOpenTime,
    String? shopCloseTime,
    RoleSpecificData? roleSpecificData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      currentRole: currentRole ?? this.currentRole,
      availableRoles: availableRoles ?? this.availableRoles,
      canSwitchRoles: canSwitchRoles ?? this.canSwitchRoles,
      primaryAddress: primaryAddress ?? this.primaryAddress,
      addresses: addresses ?? this.addresses,
      shopImage: shopImage ?? this.shopImage,
      shopOpenTime: shopOpenTime ?? this.shopOpenTime,
      shopCloseTime: shopCloseTime ?? this.shopCloseTime,
      roleSpecificData: roleSpecificData ?? this.roleSpecificData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isBusiness => currentRole == 'Business' || userType == 'Business';
  bool get isPetOwner => currentRole == 'Pet Owner' || userType == 'Pet Owner';
  bool get hasBusinessAccess => availableRoles?.contains('Business') ?? false;
  bool get hasPetOwnerAccess => availableRoles?.contains('Pet Owner') ?? false;
  
  String get displayAddress {
    if (primaryAddress != null) {
      return '${primaryAddress!.city}, ${primaryAddress!.state}';
    }
    return 'No address set';
  }
}

class AddressModel {
  final String? id;
  final String? label;
  final String? streetName;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final bool? isPrimary;
  final bool? isActive;

  AddressModel({
    this.id,
    this.label,
    this.streetName,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.isPrimary,
    this.isActive,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      label: json['label'],
      streetName: json['streetName'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      isPrimary: json['isPrimary'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'streetName': streetName,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isPrimary': isPrimary,
      'isActive': isActive,
    };
  }

  String get fullAddress {
    return '$streetName, $city, $state $zipCode';
  }
}

class RoleSpecificData {
  final PetOwnerData? petOwner;
  final BusinessData? business;

  RoleSpecificData({
    this.petOwner,
    this.business,
  });

  factory RoleSpecificData.fromJson(Map<String, dynamic> json) {
    return RoleSpecificData(
      petOwner: json['petOwner'] != null 
          ? PetOwnerData.fromJson(json['petOwner'])
          : null,
      business: json['business'] != null 
          ? BusinessData.fromJson(json['business'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petOwner': petOwner?.toJson(),
      'business': business?.toJson(),
    };
  }
}

class PetOwnerData {
  final bool? hasAccess;

  PetOwnerData({
    this.hasAccess,
  });

  factory PetOwnerData.fromJson(Map<String, dynamic> json) {
    return PetOwnerData(
      hasAccess: json['hasAccess'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasAccess': hasAccess,
    };
  }
}

class BusinessData {
  final bool? hasAccess;
  final String? shopImage;
  final String? shopOpenTime;
  final String? shopCloseTime;

  BusinessData({
    this.hasAccess,
    this.shopImage,
    this.shopOpenTime,
    this.shopCloseTime,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      hasAccess: json['hasAccess'],
      shopImage: json['shopImage'],
      shopOpenTime: json['shopOpenTime'],
      shopCloseTime: json['shopCloseTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasAccess': hasAccess,
      'shopImage': shopImage,
      'shopOpenTime': shopOpenTime,
      'shopCloseTime': shopCloseTime,
    };
  }
}
