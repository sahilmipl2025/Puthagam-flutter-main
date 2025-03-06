import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/themes/app_style.dart';

import '../utils/size_utils.dart';

// ignore: must_be_immutable
class CustomPhoneNumber extends StatelessWidget {
  CustomPhoneNumber(
      {Key? key,
      required this.country,
      required this.onTap,
      required this.controller})
      : super(key: key);

  Country country;

  Function(Country) onTap;

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _openCountryPicker(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 10 : 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                width: 1,
                color: Colors.white,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: getPadding(
                    left: 9,
                    top: 9,
                    bottom: 9,
                  ),
                  child: CountryPickerUtils.getDefaultFlagImage(
                    country,
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 8,
                    top: 16,
                    bottom: 18,
                  ),
                  child: Text(
                    "+${country.phoneCode}",
                    style: AppStyle.txtPoppinsMedium14.copyWith(
                      color: Colors.white,
                      letterSpacing: getHorizontalSize(
                        0.42,
                      ),
                      height: getVerticalSize(
                        1.00,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 0.0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 10 : 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                width: 1,
                color: Colors.white,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter 10 digit phone number".tr,
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 15,
                  ),
                ),
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Container(
            margin: EdgeInsets.only(
              left: getHorizontalSize(10),
            ),
            width: getHorizontalSize(60.0),
            child: Text(
              "+${country.phoneCode}",
              style: TextStyle(fontSize: getFontSize(14)),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(fontSize: getFontSize(14)),
            ),
          ),
        ],
      );

  void _openCountryPicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: getFontSize(14)),
          ),
          isSearchable: true,
          title: Text('Select your country code',
              style: TextStyle(fontSize: getFontSize(14))),
          onValuePicked: (Country country) => onTap(country),
          itemBuilder: _buildDialogItem,
        ),
      );
}
