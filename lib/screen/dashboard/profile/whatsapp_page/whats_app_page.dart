import 'package:country_pickers/country.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:puthagam/screen/dashboard/profile/whatsapp_page/whats_app_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/size_utils.dart';
import 'package:puthagam/utils/themes/app_style.dart';
import 'package:puthagam/widgets/custom_phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class WhatsAppPage extends StatefulWidget {
  const WhatsAppPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppPage> createState() => _WhatsAppPageState();
}

class _WhatsAppPageState extends State<WhatsAppPage> {
  WhatsAppController con = Get.put(WhatsAppController());
  RxString phoneError = ''.obs;
void validatePhoneNumber(String phone) {
  if (phone.isEmpty) {
    phoneError.value = 'Phone number is required';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(phone) || phone.length < 10) {
    phoneError.value = 'Please enter a valid phone number';
  } else {
    phoneError.value = '';
  }
}
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: verticalGradient),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => con.fromRegister.isFalse
                                ? InkWell(
                                    onTap: () => Get.back(),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox()),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Whatsapp Notification',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            decoration: BoxDecoration(
                                gradient: verticalGradient,
                                borderRadius: BorderRadius.circular(16)),
                            child: Obx(
                              () {
                                return con.isNumberPreExistBool.value
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            child: Text(
                                              "Please_enter_your_Whatsapp_Number"
                                                  .tr,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          10.heightBox,
                                          const Divider(
                                              thickness: 1,
                                              color: Colors.white),
                                          20.heightBox,
                                          SizedBox(
                                            child: Obx(
  () => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomPhoneNumber(
        country: con.selectedCountry.value,
        controller: con.phoneNumberController,
        onTap: (Country country) {
          con.selectedCountry.value = country;
        },

        // Add a listener to validate phone number when changed
        //onChanged: (value) => validatePhoneNumber(value),
      ),
      // Display error message if validation fails
      if (phoneError.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            phoneError.value,
            style: TextStyle(color: Colors.red),
          ),
        ),
    ],
  //),
                                            //  Obx(
                                            //   () => CustomPhoneNumber(
                                            //       country:
                                            //           con.selectedCountry.value,
                                            //       controller:
                                            //           con.phoneNumberController,
                                            //       onTap: (Country country) {
                                            //         con.selectedCountry.value =
                                            //             country;
                                            //       }),
                                             ) ),
                                          ),
                                          30.heightBox,
                                          Obx(() {
                                            return con.loaderBool.value
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : SizedBox(
                                                    width: double.maxFinite,
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () => con
                                                            .validateWhatsappNumber(),
                                                        child: Container(
                                                          height: 45,
                                                          width:
                                                              Get.width * 0.3,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.1),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            50),
                                                                  ),
                                                                  gradient:
                                                                      verticalGradient),
                                                          child: Text(
                                                            'Send OTP'.tr,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          }),
                                          20.heightBox,
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: getHorizontalSize(281.00),
                                            child: Text(
                                              "msg_enter_the_4_digit".tr,
                                              maxLines: null,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          5.heightBox,
                                          SizedBox(
                                            width: getHorizontalSize(281.00),
                                            child: Text(
                                              "+${con.selectedCountry.value.phoneCode}-${con.phoneNumberController.text}",
                                              maxLines: null,
                                              textAlign: TextAlign.center,
                                              style: AppStyle
                                                  .txtPTSerifRegular16
                                                  .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.72),
                                                height: getVerticalSize(1.20),
                                              ),
                                            ),
                                          ),
                                          15.heightBox,
                                          Padding(
                                              padding: getPadding(
                                                  left: 12, top: 0, right: 12),
                                              child: PinCodeTextField(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                appContext: context,
                                                length: 4,
                                                obscureText: false,
                                                hintCharacter: '',
                                                textStyle: const TextStyle(
                                                    color: Colors.white),
                                                blinkWhenObscuring: false,
                                                autoDismissKeyboard: true,
                                                enableActiveFill: true,
                                                animationType:
                                                    AnimationType.fade,
                                                validator: (v) {
                                                  return;
                                                },
                                                pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  fieldHeight:
                                                      getHorizontalSize(44),
                                                  fieldWidth:
                                                      getHorizontalSize(44.00),
                                                  inactiveColor: text23,
                                                  inactiveFillColor: Colors
                                                      .transparent
                                                      .withOpacity(.0),
                                                  selectedFillColor:
                                                      Colors.white,
                                                  selectedColor: borderColor,
                                                  activeColor: commonBlueColor,
                                                  activeFillColor:
                                                      commonBlueColor,
                                                ),
                                                cursorColor: Colors.black,
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 300),
                                                controller: con.otpController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                boxShadows: const [
                                                  BoxShadow(
                                                    offset: Offset(0, 1),
                                                    color: Colors.transparent,
                                                    blurRadius: 10,
                                                  )
                                                ],
                                                onChanged: (value) {},
                                                beforeTextPaste: (text) {
                                                  return true;
                                                },
                                              )),
                                          20.heightBox,
                                          Obx(() {
                                            return con.loaderBool.value
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : SizedBox(
                                                    width: double.maxFinite,
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () =>
                                                            con.verifyOTP(),
                                                        child: Container(
                                                          height: 45,
                                                          width:
                                                              Get.width * 0.4,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.1),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            50),
                                                                  ),
                                                                  gradient:
                                                                      verticalGradient),
                                                          child: Text(
                                                            "Verify OTP".tr,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          }),
                                          30.heightBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () => con
                                                    .resendNotificationMethod(),
                                                child: SizedBox(
                                                  height: 45,
                                                  child: Text(
                                                    'Resend OTP'.tr,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              5.widthBox,
                                              InkWell(
                                                onTap: () {
                                                  con.isNumberPreExistBool
                                                      .value = true;

                                                  setState(() {
                                                    con.otpController.clear();
                                                    con.otpController.dispose();
                                                    con.phoneNumberController
                                                        .clear();
                                                  });
                                                },
                                                child: SizedBox(
                                                  height: 45,
                                                  child: Text(
                                                    'Change Number'.tr,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ),
                          Obx(() => con.fromRegister.value
                              ? InkWell(
                                  onTap: () {
                                    Get.offAllNamed(
                                        AppRoutes.selectTopicsScreen,
                                        arguments: false);
                                        FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Skip",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox())
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                    child: RichText(
                      text: TextSpan(
                        text:
                            'We value your privacy. The phone number we collect is only for important updates related to your subscription and relevant content. For further details please read our ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                  color: Colors.blue.shade100,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(
                                      'https://admin.magic20.co.in/Pages/PrivacyPolicy.html'));
                                })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class WhatsAppOTPScreen extends StatefulWidget {
//   const WhatsAppOTPScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WhatsAppOTPScreen> createState() => _WhatsAppOTPScreenState();
// }
//
// class _WhatsAppOTPScreenState extends State<WhatsAppOTPScreen> {
//   WhatsAppController con = Get.put(WhatsAppController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         decoration: BoxDecoration(gradient: verticalGradient),
//         child: Stack(
//           children: [
//             SizedBox(
//               height: Get.height,
//               width: Get.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(gradient: verticalGradient),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 16),
//                       child: SafeArea(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap: () => Get.back(),
//                               child: const Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const Expanded(
//                               child: Center(
//                                 child: Text(
//                                   'WhatsApp notification',
//                                   style: TextStyle(
//                                     fontSize: 19,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   con.isOtpMatched.value
//                       ? Flexible(
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 gradient: verticalGradient,
//                                 borderRadius: BorderRadius.circular(16)),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 15),
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 15),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 16),
//                                   child: Text(
//                                     "Status".tr,
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 const Divider(
//                                     thickness: 1, color: Colors.white),
//                                 12.heightBox,
//                                 Padding(
//                                   padding: getPadding(top: 10),
//                                   child: Text(
//                                     "Congratulations, \n OTP Matched".tr,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.center,
//                                     style: AppStyle.txtPoppinsRegular12WhiteA700
//                                         .copyWith(
//                                       letterSpacing: getHorizontalSize(0.72),
//                                       height: getVerticalSize(1.00),
//                                     ),
//                                   ),
//                                 ),
//                                 15.heightBox,
//                                 Obx(() {
//                                   return con.loaderBool.value
//                                       ? const Center(
//                                           child: CircularProgressIndicator())
//                                       : SizedBox(
//                                           width: double.maxFinite,
//                                           child: Center(
//                                             child: InkWell(
//                                               onTap: () {
//                                                 // updateWaNumber(true);
//                                                 con.isNumberPreExistBool.value =
//                                                     true;
//                                               },
//                                               child: Container(
//                                                 height: 45,
//                                                 width: Get.width * 0.3,
//                                                 margin: EdgeInsets.symmetric(
//                                                     horizontal:
//                                                         Get.width * 0.1),
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 4),
//                                                 alignment: Alignment.center,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         const BorderRadius.all(
//                                                       Radius.circular(50),
//                                                     ),
//                                                     gradient: verticalGradient),
//                                                 child: Text(
//                                                   'Save_Number'.tr,
//                                                   style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                 }),
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         con.resendNotificationMethod();
//
//                                         setState(() {
//                                           con.otpController.text = '';
//                                           con.otpController.clear();
//                                           con.isOtpMatched.value = false;
//                                         });
//                                         Get.back();
//                                       },
//                                       child: SizedBox(
//                                         child: Text(
//                                           'resend_otp'.tr,
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         // margin: getMargin(left: 1, bottom: 120)
//                                       ),
//                                     ),
//                                     5.widthBox,
//                                     InkWell(
//                                       onTap: () {
//                                         con.isNumberPreExistBool.value = true;
//
//                                         setState(() {
//                                           con.otpController.text = '';
//                                           con.otpController.clear();
//
//                                           con.phoneNumberController.clear();
//                                           con.isOtpMatched.value = false;
//                                         });
//                                         Get.back();
//                                       },
//                                       child: SizedBox(
//                                         child: Text(
//                                           'change_mobile_number'.tr,
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Flexible(
//                           child: Container(
//                               decoration: BoxDecoration(
//                                   gradient: verticalGradient,
//                                   borderRadius: BorderRadius.circular(16)),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 15),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 15),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Text(
//                                       "Status".tr,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                   const Divider(
//                                       thickness: 1, color: Colors.white),
//                                   12.heightBox,
//                                   Obx(
//                                     () {
//                                       return Visibility(
//                                         visible: !con.isOtpMatched.value,
//                                         child: Padding(
//                                           padding:
//                                               getPadding(top: 15, bottom: 15),
//                                           child: Text(
//                                             "Sorry, OTP is Incorrect,\n Number is not validated for WhatsApp"
//                                                 .tr,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                             maxLines: 3,
//                                             style: AppStyle
//                                                 .txtPoppinsRegular12WhiteA700
//                                                 .copyWith(
//                                               letterSpacing:
//                                                   getHorizontalSize(0.72),
//                                               height: getVerticalSize(1.00),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   Obx(
//                                     () {
//                                       return Visibility(
//                                         visible: !con.isOtpMatched.value,
//                                         child: Padding(
//                                           padding:
//                                               getPadding(top: 15, bottom: 15),
//                                           child: Text(
//                                             "Do you still wish to save the number \n or \n You can Retry"
//                                                 .tr,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                             maxLines: 3,
//                                             style: AppStyle
//                                                 .txtPoppinsRegular12WhiteA700
//                                                 .copyWith(
//                                               letterSpacing:
//                                                   getHorizontalSize(0.72),
//                                               height: getVerticalSize(1.00),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   12.heightBox,
//                                   Obx(() {
//                                     return con.loaderBool.value
//                                         ? const Center(
//                                             child: CircularProgressIndicator())
//                                         : SizedBox(
//                                             width: double.maxFinite,
//                                             child: Center(
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   updateWaNumber(false);
//                                                   con.isNumberPreExistBool
//                                                       .value = true;
//                                                 },
//                                                 child: Container(
//                                                   height: 45,
//                                                   width: Get.width * 0.3,
//                                                   padding: const EdgeInsets
//                                                       .symmetric(horizontal: 5),
//                                                   margin: EdgeInsets.symmetric(
//                                                       horizontal:
//                                                           Get.width * 0.1),
//                                                   alignment: Alignment.center,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           const BorderRadius
//                                                               .all(
//                                                         Radius.circular(50),
//                                                       ),
//                                                       gradient:
//                                                           verticalGradient),
//                                                   child: Text(
//                                                     'Save_Number'.tr,
//                                                     style: const TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                   }),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           con.resendNotificationMethod();
//                                           setState(() {
//                                             con.otpController.text = '';
//                                             con.otpController.clear();
//                                             con.isOtpMatched.value = false;
//                                           });
//                                           Get.back();
//                                         },
//                                         child: SizedBox(
//                                           child: Text(
//                                             'resend_otp'.tr,
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           // margin: getMargin(left: 1, bottom: 120)
//                                         ),
//                                       ),
//                                       5.widthBox,
//                                       InkWell(
//                                         onTap: () {
//                                           con.isNumberPreExistBool.value = true;
//
//                                           setState(() {
//                                             con.otpController.text = '';
//                                             con.otpController.clear();
//
//                                             con.phoneNumberController.clear();
//                                             con.isOtpMatched.value = false;
//                                           });
//
//                                           Get.back();
//                                         },
//                                         child: SizedBox(
//                                           child: Text(
//                                             'change_mobile_number'.tr,
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           // margin: getMargin(left: 1, bottom: 120)
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   12.heightBox,
//                                 ],
//                               )),
//                         )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
