import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileRequested extends ProfileEvent {
  final String userId;

  const LoadProfileRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateProfileRequested extends ProfileEvent {
  final UserProfile profile;
  final File? image;

  const UpdateProfileRequested(this.profile, {this.image});

  @override
  List<Object?> get props => [profile, image];
}

class RefreshProfileRequested extends ProfileEvent {
  final String userId;

  const RefreshProfileRequested(this.userId);

  @override
  List<Object> get props => [userId];
}
