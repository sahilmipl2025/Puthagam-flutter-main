import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/whatsapp/update_whatsapp_number_Api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class WhatsAppController extends GetxController {
  RxBool loaderBool = false.obs;
  TextEditingController phoneNumberController = TextEditingController();
  Rx<Country> selectedCountry =
      CountryPickerUtils.getCountryByPhoneCode('91').obs;
  RxBool isNumberPreExistBool = true.obs;
  RxString otpFromBackend = "".obs;
  TextEditingController otpController = TextEditingController();

  RxBool isOtpMatched = false.obs;

  // validateWhatsappNumber() {
  //   loaderBool.value = true;
  //   if (phoneNumberController.text.isBlank == true ||
  //       phoneNumberController.text.length < 10) {
  //     toast("Please enter a valid phone number!".tr, false);
  //     loaderBool.value = false;
  //     return;
  //   } else {
  //     try {
  //       otpController = TextEditingController();
  //       var countryCode = "+" + selectedCountry.value.phoneCode;
  //       var phone = phoneNumberController.text;
  //       Future.delayed(const Duration(seconds: 1), () async {
  //         await isNumberValidMethod(whatsappNumber: countryCode + phone)
  //             .then((value) => loaderBool.value = false);
  //       });
  //     } catch (err) {
  //       loaderBool.value = false;
  //       log("err $err");
  //     }
  //   }
  // }

validateWhatsappNumber() {
  loaderBool.value = true;

  // Check if the phone number is empty or less than 10 digits
  if (phoneNumberController.text.isBlank == true|| phoneNumberController.text.length < 10) {
    toast("Please enter a valid phone number!".tr, false);
    loaderBool.value = false;
    return;
  }

  // Check if the phone number contains only digits (numeric validation)
  if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumberController.text)) {
    toast("Phone number should only contain digits".tr, false);
    loaderBool.value = false;
    return;
  }

  // If country code is +91, check if the phone number is exactly 10 digits
  var phone = phoneNumberController.text;
  if (selectedCountry.value.phoneCode == '91' && phone.length != 10) {
    toast("Phone number must be exactly 10 digits for India.".tr, false);
    loaderBool.value = false;
    return;
  }

  try {
    otpController = TextEditingController();
    var countryCode = "+" + selectedCountry.value.phoneCode;

    // Perform the number validation asynchronously
    Future.delayed(const Duration(seconds: 1), () async {
      await isNumberValidMethod(whatsappNumber: countryCode + phone)
          .then((value) {
            loaderBool.value = false;
          });
    });
  } catch (err) {
    loaderBool.value = false;
    log("err $err");
  }
}


  Future<void> isNumberValidMethod({required String whatsappNumber}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        http.Response response = await ApiHandler.post(
          url:
              "${ApiUrls.baseUrl}Auth/IsPhoneNumberExists?phoneNumber=$whatsappNumber",
        );

        var decoded = jsonDecode(response.body);
        if (decoded['isExists'] == false) {
          isNumberPreExistBool.value = false;
          http.Response response1 = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Auth/SendWhatsappVarificationCode",
              body: {
                'phoneNo':
                    "+${selectedCountry.value.phoneCode}${phoneNumberController.text}"
              });
          var decoded1 = jsonDecode(response1.body);

          otpFromBackend.value = decoded1["code"];

          if (response1.statusCode == 200 ||
              response1.statusCode == 201 ||
              response1.statusCode == 202 ||
              response1.statusCode == 203 ||
              response1.statusCode == 204) {
            toast("Success! Your 4-digit OTP has been sent to your WhatsApp number. Please check your WhatsApp messages for the code.".tr, true);
          } else {
            toast("Some Error Occurred, Please retry".tr, false);
          }

          log('otpFromBackend.value ${otpFromBackend.value}');
          log('decoded1["code"] ${decoded1["code"]}');
          return;
        } else {
          isNumberPreExistBool.value = true;

          toast("This Number belong some other User".tr, false);
          return;
        }
      } else {
        toast("No Internet Connection!".tr, false);
      }
    } catch (e) {
      toast("Some error occured! please try again".tr, false);
      log(e.toString() + ' error from isNumberValid method');
    }
  }

  Future<void> resendNotificationMethod() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        http.Response response1 = await ApiHandler.post(
          url: "${ApiUrls.baseUrl}Auth/SendWhatsappVarificationCode",
          body: {
            'phoneNo':
                "+${selectedCountry.value.phoneCode}${phoneNumberController.text}"
          },
        );
        var decoded1 = jsonDecode(response1.body);

        otpFromBackend.value = decoded1["code"];

        if (response1.statusCode == 200 ||
            response1.statusCode == 201 ||
            response1.statusCode == 202 ||
            response1.statusCode == 203 ||
            response1.statusCode == 204) {
          toast("Success! Your 4-digit OTP has been sent to your WhatsApp number. Please check your WhatsApp messages for the code. ".tr, true);
        } else {
          toast("Some Error Occurred, Please retry".tr, false);
        }

        log('otpFromBackend.value ${otpFromBackend.value}');
        log('decoded1["code"] ${decoded1["code"]}');
        return;
      } else {
        toast("No Internet Connection!".tr, false);
      }
    } catch (e) {
      toast("Some error occured! please try again".tr, false);
      log(e.toString() + ' error from isNumberValid method'.tr);
    }
  }

  void verifyOTP() async {
    loaderBool.value = true;
    if (otpController.value.text == otpFromBackend.value) {
      isOtpMatched.value = true;

      toast("OTP matched".tr, true);
      Future.delayed(const Duration(milliseconds: 1500), () {
        loaderBool.value = false;
      });

      await updateWaNumber(true, fromRegister.value);
    } else {
      loaderBool.value = false;
      toast("Invalid OTP".tr, false);
    }
  }

  RxBool fromRegister = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fromRegister.value = Get.arguments;
  }
}
