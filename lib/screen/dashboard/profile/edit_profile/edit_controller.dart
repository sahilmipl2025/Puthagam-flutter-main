import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:puthagam/data/api/profile/update_photo_api.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class EditProfileController extends GetxController {
  RxString selectedId = "".obs;
  RxBool isLoading = false.obs;
  RxBool obSecure = true.obs;
 // TextEditingController  nameController  = TextEditingController();

 // Rx<TextEditingController> nameController = TextEditingController().obs;
  TextEditingController name = TextEditingController();
    TextEditingController dob = TextEditingController();
  //Rx<TextEditingController> dobController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  @override
  void onReady() {
    super.onReady();
    name.text = LocalStorage.userName;
    dob.text = LocalStorage.userDOB;
    phoneController.value.text = LocalStorage.phoneNumber;
    
    emailController.value.text = LocalStorage.userEmail;
    passwordController.value.text = LocalStorage.password;
  }

  selectedDate(context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return SingleChildScrollView(child: child);
        });

    if (selectedDate.toString() != "null") {
      dob.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    }
  }

  Rx<File> image = File("").obs;

  Future pickImage() async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        if (pickedFile.toString() != "null") {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
            compressQuality: 20,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Edit'.tr,
                toolbarColor: Colors.blue,
                toolbarWidgetColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
              ),
              IOSUiSettings(
                title: 'Edit'.tr,
              )
            ],
          );
          if (croppedFile != null) {
            image.value = File(croppedFile.path);

            getUpdatePhoto();
          }
        }
      }
    } on PlatformException catch (e) {
      debugPrint("$e");
    }
  }

  Future pickImageCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
          compressQuality: 20,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit'.tr,
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Edit'.tr,
            )
          ],
        );
        if (croppedFile != null) {
          image.value = File(croppedFile.path);

          getUpdatePhoto();
        }
      }
    } on PlatformException catch (e) {
      debugPrint("$e");
    }
  }
}
