import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class BooksImages extends StatelessWidget {
  final String bookImage;

  const BooksImages({Key? key, required this.bookImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          child: PinchZoom(
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 5,
            onZoomStart: () {},
            onZoomEnd: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: bookImage,
                placeholder: (b, c) {
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
