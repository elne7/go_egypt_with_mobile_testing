import 'package:dartz/dartz.dart';
import 'package:go_egypt_with_firebase/core/failures.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_source/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profileModel = await remoteDataSource.getProfile();
      return Right(profileModel.toEntity());
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile) async {
    try {
      final profileModel = ProfileModel(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        password: profile.password,
        imagePath: profile.imagePath,
      );
      return Right(await remoteDataSource.updateProfile(profileModel));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async {
    await remoteDataSource.updateProfileImage(imagePath);
  }
}
