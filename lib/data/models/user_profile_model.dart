import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    required super.name,
    required super.gender,
    super.profileImageUrl,
    super.height,
    super.weight,
    super.address,
    super.city,
    super.state,
    super.familyInfo,
    super.phoneNumber,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'Bride',
      profileImageUrl: json['profileImageUrl'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      familyInfo: json['familyInfo'],
      phoneNumber: json['phoneNumber'],
    );
  }

  factory UserProfileModel.fromFirebaseUser(User user, {String? name}) {
    return UserProfileModel(
      id: user.uid,
      email: user.email ?? '',
      name: name ?? user.displayName ?? '',
      gender: 'Bride', // Default for now
      profileImageUrl: user.photoURL,
    );
  }

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? 'Bride',
      profileImageUrl: data['profileImageUrl'],
      height: (data['height'] as num?)?.toDouble(),
      weight: (data['weight'] as num?)?.toDouble(),
      address: data['address'],
      city: data['city'],
      state: data['state'],
      familyInfo: data['familyInfo'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'height': height,
      'weight': weight,
      'address': address,
      'city': city,
      'state': state,
      'familyInfo': familyInfo,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'height': height,
      'weight': weight,
      'address': address,
      'city': city,
      'state': state,
      'familyInfo': familyInfo,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? name,
    String? gender,
    String? profileImageUrl,
    double? height,
    double? weight,
    String? address,
    String? city,
    String? state,
    String? familyInfo,
    String? phoneNumber,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      familyInfo: familyInfo ?? this.familyInfo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
