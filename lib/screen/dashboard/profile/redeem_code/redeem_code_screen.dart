import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:puthagam/data/api/reedem_code/redeem_code.dart';
import 'package:puthagam/screen/dashboard/profile/redeem_code/redeem_code_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class RedeemCodeScreen extends StatelessWidget {
  RedeemCodeScreen({Key? key}) : super(key: key);

  final RedeemCodeController con = Get.put(RedeemCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(gradient: verticalGradient),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.2),
                  const Text(
                    'Redeem Code',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Text(
                      'Enter 4 digit invite code for free subscription of unlimited books and podcasts.',
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: con.formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            obscureText: false,
                            hintCharacter: '',
                            blinkWhenObscuring: false,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              return;
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 56,
                              fieldWidth: 56,
                              inactiveColor: borderColor,
                              inactiveFillColor: HexColor("#065293"),
                              selectedFillColor: Colors.white,
                              selectedColor: commonBlueColor,
                              activeColor: buttonColor,
                              activeFillColor: commonBlueColor,
                            ),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: con.errorController,
                            controller: con.textEditingController.value,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              con.currentText.value = value;
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                          )),
                    ),
                  ),
                  const SizedBox(height: 60),
                  InkWell(
                    onTap: () {
                      if (con.textEditingController.value.text.trim().length <
                          4) {
                        toast("Please enter code", false);
                      } else {
                        redeemCodeApi(
                            code: con.textEditingController.value.text);
                      }
                    },
                    child: Container(
                      height: isTablet ? 60 : 45,
                      margin:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          gradient: verticalGradient),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => con.showLoader.value
              ? Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: const AppLoader(),
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
