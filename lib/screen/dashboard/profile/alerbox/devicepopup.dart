import 'package:flutter/material.dart';
import 'package:puthagam/utils/colors.dart';

class PopupWidget extends StatefulWidget {
  const PopupWidget({Key? key}) : super(key: key);

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

enum MenuItem {
  item1,
  item2,
}

class _PopupWidgetState extends State<PopupWidget> {
  MenuItem? _mitem = MenuItem.item1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Storage Option for  download audio',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'SF-Pro-Display-Semibold',
                        fontWeight: FontWeight.w700)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: const Text(
                  'Device Storage',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'SF-Pro-Display-Medium',
                  ),
                ),
                leading: Radio<MenuItem>(
                  activeColor: buttonColor,
                  value: MenuItem.item1,
                  groupValue: _mitem,
                  onChanged: (MenuItem? value) {
                    setState(() {
                      _mitem = value;
                    });
                  },
                ),
              ),
              Divider(
                height: 2,
                color: borderColor,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: const Text(
                  'SD Card',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'SF-Pro-Display-Medium',
                  ),
                ),
                leading: Radio<MenuItem>(
                  value: MenuItem.item2,
                  activeColor: buttonColor,
                  groupValue: _mitem,
                  onChanged: (MenuItem? value) {
                    setState(() {
                      _mitem = value;
                    });
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'SF-Pro-Display-Medium',
                          fontWeight: FontWeight.w700,
                          color: buttonColor),
                      textAlign: TextAlign.right,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
