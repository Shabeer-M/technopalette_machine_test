import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String name;
  final String gender;
  final String? profileImageUrl;
  final double? height;
  final double? weight;
  final String? address;
  final String? city;
  final String? state;
  final String? familyInfo;
  final String? phoneNumber;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.gender = 'Bride',
    this.profileImageUrl,
    this.height,
    this.weight,
    this.address,
    this.city,
    this.state,
    this.familyInfo,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    gender,
    profileImageUrl,
    height,
    weight,
    address,
    city,
    state,
    state,
    familyInfo,
    phoneNumber,
  ];
}
