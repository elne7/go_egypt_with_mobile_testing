import 'package:dartz/dartz.dart';
import 'package:go_egypt_with_firebase/core/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure,void>> call(ProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }
}
