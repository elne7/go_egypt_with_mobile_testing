import 'package:dartz/dartz.dart';
import 'package:go_egypt_with_firebase/core/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure,ProfileEntity>> call() async {
    return await repository.getProfile();
  }
}
