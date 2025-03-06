// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:puthagam/main.dart';
// import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
// import 'package:puthagam/utils/colors.dart';
// import 'package:puthagam/utils/themes/global.dart';
// import 'package:square_percent_indicater/square_percent_indicater.dart';
//
// class DownloadBottomAudio extends StatelessWidget {
//   DownloadBottomAudio({Key? key}) : super(key: key);
//
//   final DownloadBookDetailController con =
//       Get.put(DownloadBookDetailController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => baseController!.currentPlayingIndex.value != 999 &&
//             jsonDecode(con.data.value['chapter']).isNotEmpty
//         ? Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//                 padding: const EdgeInsets.only(left: 12),
//                 decoration: BoxDecoration(
//                   gradient: horizontalGradient,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 height: 80,
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       padding: const EdgeInsets.only(
//                         left: 10,
//                         right: 12,
//                         top: 10,
//                         bottom: 12,
//                       ),
//                       child: Row(
//                         children: [
//                           Obx(() => InkWell(
//                                 onTap: () {
//                                   con.myQueue(
//                                     context: context,
//                                     index: baseController!
//                                         .currentPlayingIndex.value,
//                                   );
//                                 },
//                                 child: SquarePercentIndicator(
//                                   width: 40,
//                                   height: 40,
//                                   startAngle: StartAngle.topLeft,
//                                   reverse: true,
//                                   borderRadius: 12,
//                                   shadowWidth: 2,
//                                   progressWidth: 5,
//                                   shadowColor: Colors.grey,
//                                   progressColor:
//                                       GlobalService.to.isDarkModel == true
//                                           ? Colors.white
//                                           : Colors.orange,
//                                   progress: con.position.value.inSeconds /
//                                       con.duration.value.inSeconds,
//                                   child: Container(
//                                     height: 46,
//                                     width: 46,
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                             image: NetworkImage(baseController!
//                                                 .runningBookImage.value),
//                                             fit: BoxFit.contain),
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(12))),
//                                   ),
//                                 ),
//                               )),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 con.myQueue(
//                                     context: context,
//                                     index: baseController!
//                                         .currentPlayingIndex.value);
//                               },
//                               child: Wrap(
//                                 children: [
//                                   Text(
//                                     'Ch : ${baseController!.currentPlayingIndex.value + 1}  ' +
//                                         baseController!
//                                             .booksQueueList[baseController!
//                                                 .currentPlayingBookIndex.value]
//                                             .bookChapter[baseController!
//                                                 .currentPlayingIndex.value]
//                                             .name
//                                             .toString(),
//                                     maxLines: 2,
//                                     style: const TextStyle(
//                                       overflow: TextOverflow.ellipsis,
//                                       color: Colors.white,
//                                       fontSize: 17,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           baseController!.booksQueueList.isNotEmpty &&
//                                   baseController!.booksQueueList.length != 1
//                               ? CircleAvatar(
//                                   backgroundColor:
//                                       GlobalService.to.isDarkModel == true
//                                           ? Colors.grey.withOpacity(.3)
//                                           : buttonColor,
//                                   radius: 18,
//                                   child: IconButton(
//                                     onPressed: () async {
//                                       showModalBottomSheet(
//                                         isScrollControlled: true,
//                                         context: context,
//                                         backgroundColor:
//                                             GlobalService.to.isDarkModel == true
//                                                 ? Colors.grey.withOpacity(.3)
//                                                 : buttonColor,
//                                         constraints:
//                                             const BoxConstraints(maxWidth: 800),
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.vertical(
//                                               top: Radius.circular(25.0)),
//                                         ),
//                                         builder: (context) {
//                                           return StatefulBuilder(
//                                             builder: (BuildContext context,
//                                                 StateSetter setState) {
//                                               return Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey,
//                                                   borderRadius:
//                                                       BorderRadius.circular(30),
//                                                 ),
//                                                 height: Get.height * 0.5,
//                                                 width: Get.width,
//                                                 child: Column(
//                                                   children: [
//                                                     const SizedBox(height: 16),
//                                                     const Text(
//                                                       "Book Queue",
//                                                       style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 16),
//                                                     Expanded(
//                                                       child: ListView.builder(
//                                                         itemCount:
//                                                             baseController
//                                                                 ?.booksQueueList
//                                                                 .length,
//                                                         itemBuilder:
//                                                             (BuildContext
//                                                                     context,
//                                                                 int index) {
//                                                           return Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 10,
//                                                                     bottom: 5),
//                                                             child: Column(
//                                                               children: [
//                                                                 InkWell(
//                                                                   onTap: () {
//                                                                     if (index !=
//                                                                         baseController!
//                                                                             .currentPlayingBookIndex
//                                                                             .value) {
//                                                                       baseController!
//                                                                           .currentPlayingBookIndex
//                                                                           .value = index;
//                                                                       baseController!
//                                                                           .audioPlayer
//                                                                           .dispose();
//                                                                       baseController!
//                                                                               .audioPlayer =
//                                                                           AudioPlayer();
//                                                                       baseController!
//                                                                           .isPlaying
//                                                                           .value = false;
//                                                                       baseController!
//                                                                           .currentPlayingIndex
//                                                                           .value = 0;
//                                                                       con
//                                                                           .setAudio(
//                                                                               fromQueue: false,
//                                                                               index: 0)
//                                                                           .then((value) {
//                                                                         baseController!
//                                                                             .isPlaying
//                                                                             .value = true;
//                                                                         setState(
//                                                                             () {});
//                                                                       });
//                                                                     }
//                                                                   },
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .spaceBetween,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child:
//                                                                             Row(
//                                                                           children: [
//                                                                             const SizedBox(width: 10),
//                                                                             SquarePercentIndicator(
//                                                                               width: 50,
//                                                                               height: 50,
//                                                                               startAngle: StartAngle.topLeft,
//                                                                               reverse: true,
//                                                                               borderRadius: 12,
//                                                                               shadowWidth: 2,
//                                                                               progressWidth: 5,
//                                                                               shadowColor: Colors.white,
//                                                                               progressColor: GlobalService.to.isDarkModel == true ? Colors.white : Colors.orange,
//                                                                               progress: 0,
//                                                                               child: Container(
//                                                                                 height: 56,
//                                                                                 width: 56,
//                                                                                 decoration: BoxDecoration(
//                                                                                   image: DecorationImage(image: NetworkImage(baseController!.booksQueueList[index].bookImage), fit: BoxFit.contain),
//                                                                                   borderRadius: const BorderRadius.all(
//                                                                                     Radius.circular(12),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                             const SizedBox(width: 12),
//                                                                             Expanded(
//                                                                               child: Column(
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: [
//                                                                                   Text(
//                                                                                     baseController!.booksQueueList[index].bookTitle.toString(),
//                                                                                     maxLines: 2,
//                                                                                     style: const TextStyle(
//                                                                                       fontSize: 17,
//                                                                                       color: Colors.white,
//                                                                                       fontWeight: FontWeight.w500,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                             const SizedBox(width: 6),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Obx(
//                                                                         () =>
//                                                                             Row(
//                                                                           children: [
//                                                                             baseController!.currentPlayingBookIndex.value == index
//                                                                                 ? IconButton(
//                                                                                     icon: Image.asset(
//                                                                                       "assets/images/audio.png",
//                                                                                       height: 30,
//                                                                                       width: 30,
//                                                                                       color: GlobalService.to.isDarkModel == true ? Colors.white : buttonColor,
//                                                                                     ),
//                                                                                     onPressed: () {},
//                                                                                   )
//                                                                                 : index > baseController!.currentPlayingBookIndex.value
//                                                                                     ? IconButton(
//                                                                                         icon: const Icon(Icons.remove_circle_outline),
//                                                                                         onPressed: () {
//                                                                                           baseController!.booksQueueList.removeAt(index);
//                                                                                           setState(() {});
//                                                                                         },
//                                                                                       )
//                                                                                     : const SizedBox()
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       const SizedBox(
//                                                                           width:
//                                                                               6),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                     height: 8),
//                                                                 Divider(
//                                                                   thickness: 1,
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .withOpacity(
//                                                                           0.3),
//                                                                   indent: 0,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           );
//                                                         },
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                       );
//                                     },
//                                     icon: const Icon(
//                                       Icons.queue_music,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox(),
//                           const SizedBox(width: 4),
//                           Obx(
//                             () => CircleAvatar(
//                               backgroundColor:
//                                   GlobalService.to.isDarkModel == true
//                                       ? Colors.grey.withOpacity(.3)
//                                       : buttonColor,
//                               radius: 18,
//                               child: IconButton(
//                                 onPressed: () async {
//                                   if (baseController!.isPlaying.value) {
//                                     baseController!.audioPlayer.pause();
//                                     baseController!.isPause.value = true;
//                                     baseController!.isPlaying.value = false;
//                                   } else {
//                                     if (baseController!.isPause.value == true) {
//                                       baseController!.audioPlayer.play();
//
//                                       baseController!.isPlaying.value = true;
//                                       baseController!.isPause.value = false;
//                                     } else {
//                                       baseController!.audioPlayer.dispose();
//                                       baseController!.audioPlayer =
//                                           AudioPlayer();
//
//                                       baseController!.audioPlayer.pause();
//                                       con.setAudio().then((value) {
//                                         baseController!.isPlaying.value = true;
//                                       });
//                                     }
//                                   }
//                                 },
//                                 icon: Icon(
//                                   baseController!.isPlaying.value
//                                       ? Icons.pause
//                                       : Icons.play_arrow,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           CircleAvatar(
//                             backgroundColor:
//                                 GlobalService.to.isDarkModel == true
//                                     ? Colors.grey.withOpacity(.3)
//                                     : buttonColor,
//                             radius: 18,
//                             child: IconButton(
//                               onPressed: () async {
//                                 baseController!.audioPlayer.pause();
//                                 baseController!.isPause.value = true;
//                                 baseController!.isPlaying.value = false;
//                                 baseController!.audioPlayer.dispose();
//                                 baseController!.currentPlayingIndex.value = 999;
//                                 baseController!.booksQueueList.clear();
//                               },
//                               icon: const Icon(
//                                 Icons.stop,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )))
//         : const SizedBox());
//   }
// }
