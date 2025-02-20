import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_egypt_with_firebase/core/helpers/shared_pref_helper.dart';
import 'package:go_egypt_with_firebase/features/auth/data/models/signup_model.dart';
import 'package:go_egypt_with_firebase/features/profile/domain/entities/profile_entity.dart';
import 'package:image_picker/image_picker.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImagePicker picker = ImagePicker();
  final db = FirebaseFirestore.instance;
  bool changeImgWithCam = false;
  bool? isProfileImgDeleted;
  String? localImgPath = "";
  String? deleteImagePath;
  File? profileImg;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        var user = await getUserData();
        deleteImagePath = "assets/images/profile image.png";
        localImgPath = await SharedPrefHelper.getString("localImgPath");
        if (localImgPath == "") {
          isProfileImgDeleted = true;
        } else {
          isProfileImgDeleted = false;
          profileImg = File(localImgPath!);
        }
        Future.delayed(Duration(seconds: 5));
        emit(ProfileLoaded(user));
      } catch (e) {
        print(e.toString());
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profileUpdate = event.profileData;
        updateUserData(user: profileUpdate);
        emit(ProfileUpdated(profileUpdate));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateAvatar>((event, emit) async {
      emit(ProfileLoading());
      try {
        if (!isProfileImgDeleted!) {
          await changeProfileImage();
          profileImg = File(localImgPath!);
          await SharedPrefHelper.setData('localImgPath', localImgPath);
        } else if (isProfileImgDeleted!) {
          await SharedPrefHelper.setData('localImgPath', "");
        }
        final name = await SharedPrefHelper.getString("name") ?? "";
        final phone = await SharedPrefHelper.getString("phone") ?? "";
        final email = await SharedPrefHelper.getString("email") ?? "";
        final password = await SharedPrefHelper.getString("pass") ?? "";

        final user = SignUpModel(
          name: name,
          email: email,
          password: password,
          phone: phone,
        );
        emit(ProfileUpdated(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }

  void toggleAvatar() {
    deleteImagePath = deleteImagePath == "assets/images/boy_avatar.jpeg"
        ? "assets/images/girl_avatar.jpeg"
        : "assets/images/boy_avatar.jpeg";
    SharedPrefHelper.setData('path', deleteImagePath);
  }

  Future<SignUpModel> getUserData() async {
    String email = await SharedPrefHelper.getString('email');
    late SignUpModel user;
    await db.collection('users').get().then((event) {
      for (var doc in event.docs) {
        if (SignUpModel.fromFireStore(doc.data()).email == email) {
          user = SignUpModel.fromFireStore(doc.data());
        }
      }
    });
    return user;
  }

  updateUserData({required SignUpModel user}) async {
    String id = await SharedPrefHelper.getString('UserID');
    final washingtonRef = db.collection("users").doc(id);
    washingtonRef.update(user.toFireStore()).then(
          (value) => print("DocumentSnapshot successfully updated!"),
    );
  }

  changeProfileImage() async {
    final image = await picker.pickImage(
        source: changeImgWithCam ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      localImgPath = image.path;
    }
  }
}