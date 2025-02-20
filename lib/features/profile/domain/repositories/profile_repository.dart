import 'package:dartz/dartz.dart';
import 'package:go_egypt_with_firebase/core/failures.dart';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure,ProfileEntity>> getProfile();
  Future<Either<Failure,void>> updateProfile(ProfileEntity profile);
  Future<void> updateProfileImage(String imagePath);
}
