import '../../../../provider/auth_provider/registerprovider.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final UserType userType;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "userType": userType.name,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    password: json['password'],
    userType: json['userType'] == 'business'
        ? UserType.business
        : UserType.petOwner,
  );
}
