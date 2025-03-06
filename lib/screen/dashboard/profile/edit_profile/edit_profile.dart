import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:puthagam/data/api/profile/update_profile_api.dart';
import 'package:puthagam/screen/dashboard/profile/edit_profile/edit_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  final EditProfileController con = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: verticalGradient),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => Get.back(),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        fontSize: isTablet ? 23 : 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isTablet ? 24 : 20),
                              ],
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            Obx(
                              () => Stack(
                                alignment: Alignment.center,
                                children: [
                                  con.image.value.path.toString() != "null" &&
                                          con.image.value.path.toString() != ""
                                      ? ClipOval(
                                          child: Container(
                                            width: isTablet ? 140 : 120,
                                            height: isTablet ? 140 : 120,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: textColor),
                                              image: DecorationImage(
                                                image:
                                                    FileImage(con.image.value),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () => _showDialog(context),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: isTablet ? 140 : 120,
                                            width: isTablet ? 140 : 120,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: textColor),
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircleAvatar(
                                              radius: isTablet ? 85 : 75,
                                              backgroundImage: NetworkImage(
                                                LocalStorage.profileImage,
                                              ),
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 04,
                                    right: 10,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: isTablet ? 38 : 35,
                                      width: isTablet ? 38 : 35,
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        onTap: () => _showDialog(context),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 28 : 24,
                                vertical: isTablet ? 24 : 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Full name',
                                  style: TextStyle(
                                    fontSize: isTablet ? 19 : 17,
                                  ),
                                ),
                                TextField(
                                  controller: con.name,
                                  //controller: con.nameController.value,
                                  decoration: InputDecoration(
                                    hintText: 'Enter full name',
                                    helperStyle: TextStyle(
                                      fontSize: isTablet ? 18 : 15,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(fontSize: isTablet ? 18 : 15),
                                ),
                                Divider(
                                    height: isTablet ? 3 : 2,
                                    color: Colors.white),
                                SizedBox(height: isTablet ? 20 : 16),
                                LocalStorage.userEmail.isNotEmpty
                                    ? Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: isTablet ? 19 : 17,
                                        ),
                                      )
                                    : const SizedBox(),
                                LocalStorage.userEmail.isNotEmpty
                                    ? TextField(
                                        enabled: false,
                                        controller: con.emailController.value,
                                        decoration: InputDecoration(
                                          hintText: 'Enter email',
                                          helperStyle: TextStyle(
                                            fontSize: isTablet ? 18 : 15,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            fontSize: isTablet ? 18 : 15),
                                      )
                                    : const SizedBox(),
                                Divider(
                                    height: isTablet ? 3 : 2,
                                    color: Colors.white),
                                SizedBox(height: isTablet ? 20 : 16),
                                LocalStorage.phoneNumber.isNotEmpty
                                    ? Text(
                                        'Phone number',
                                        style: TextStyle(
                                          fontSize: isTablet ? 19 : 17,
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LocalStorage.phoneNumber.isNotEmpty
                                        ? Flexible(
                                            child: Obx(
                                              () => TextField(
                                                enabled: false,
                                                controller:
                                                    con.phoneController.value,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter mobile number',
                                                  helperStyle: TextStyle(
                                                    fontSize:
                                                        isTablet ? 17 : 15,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 18 : 15),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    LocalStorage.isPhoneVerified == true
                                        ? Flexible(
                                            child: ListTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_rounded,
                                                    color: Colors.green,
                                                  ),
                                                  Text(
                                                    ' verified  ',
                                                    style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 18 : 15),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                LocalStorage.phoneNumber.isNotEmpty
                                    ? const Divider(
                                        height: 2, color: Colors.white)
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          InkWell(
                            onTap: () async {
                              Future.delayed(Duration(milliseconds: 100), () {
                                FocusScope.of(context).unfocus();

                                // Get the name value
                                String name = con.name.text.trim();
                                String dob = con.dob.text
                                    .trim(); // Assuming dobController is a TextEditingController

                                // Name validations
                                if (name.isEmpty) {
                                  toast("Name is required", false);
                                } else if (name.length < 2) {
                                  toast(
                                      "Name must be at least 2 characters long",
                                      false);
                                } else if (name.length > 50) {
                                  toast("Name cannot exceed 50 characters",
                                      false);
                                } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                    .hasMatch(name)) {
                                  toast(
                                      "Name can only contain letters and spaces",
                                      false);
                                }
                                // DOB validation
                                else if (dob.isEmpty) {
                                  toast("Date of birth is required", false);
                                }
                                // Proceed if all validations pass
                                else {
                                  print("Name: $name, DOB: $dob");
                                  updateProfileApi(name: name, dob: dob);
                                  // con.updateProfileApi(name: name, dob: dob);
                                }
                              });
                              //FocusScope.of(context).unfocus();
                              // Future.delayed(Duration(milliseconds: 100), () {
                              //   FocusScope.of(context).unfocus();
                              //   String name =
                              //       con.name.text.trim();
                              //   if (name.isEmpty) {
                              //     print("Name is empty");
                              //     return; // Handle empty name case
                              //   }

                              //   if (name.isEmpty) {
                              //     toast("Name is required", false);
                              //   } else if (name.length < 2) {
                              //     toast(
                              //         "Name must be at least 2 characters long",
                              //         false);
                              //   } else if (name.length > 50) {
                              //     toast("Name cannot exceed 50 characters",
                              //         false);
                              //   } else if (!RegExp(r'^[a-zA-Z\s]+$')
                              //       .hasMatch(name)) {
                              //     toast(
                              //         "Name can only contain letters and spaces",
                              //         false);
                              //   } else {
                              //     print(
                              //         "con.nameController.value.text before ${con.name.text}");
                              //     updateProfileApi(name: name,dobController:);
                              //   }
                              // });

                              //   FocusScope.of(context).unfocus();
                              //   if (con.nameController.value.text
                              //       .trim()
                              //       .isNotEmpty) {
                              //     updateProfileApi();
                              //   } else {
                              //     toast("Name is required", false);
                              //   }
                            },
                            child: Container(
                              width: Get.width * 0.6,
                              height: isTablet ? 54 : 45,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  gradient: verticalGradient),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 20 : 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => con.isLoading.value
                ? Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Container(
            decoration: BoxDecoration(gradient: verticalGradient),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    'Upload your picture from',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        con.pickImageCamera();
                        Get.back();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/icons/camera.png",
                            height: 50,
                            width: 50,
                            color: Colors.white,
                          ),
                          const Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        height: 50,
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        con.pickImage();
                        Get.back();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/icons/gallery.png",
                            height: 50,
                            width: 50,
                            color: Colors.white,
                          ),
                          const Text(
                            'Gallery',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
