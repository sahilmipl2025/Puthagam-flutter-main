import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class BuildNetworkImage extends StatelessWidget {
  const BuildNetworkImage(
      {Key? key,
      required this.image,
      required this.width,
      required this.height})
      : super(key: key);
  final String? image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return image != null
        ? SizedBox(
            // height: 130,
            // width: 90,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: image!,
                  placeholder: (b, c) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/notfound.png",
                        ));
                  },
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ))

            // SizedBox(
            //     height: 110,
            //     width: 90,
            //     child: Image.network(
            //       image!,
            //       width: width,
            //       height: height,
            //       fit: BoxFit.contain,
            //       errorBuilder: ((context, error, stackTrace) {
            //         return ClipRRect(
            //             borderRadius: BorderRadius.circular(8),
            //             child: Image.asset(
            //               "assets/images/notfound.png",
            //             ));
            //       }),
            //     ),
            //   )
            )
        : Image.asset(
            "assets/images/notfound.png",
            width: 90,
            height: 130,
          );
  }
}
