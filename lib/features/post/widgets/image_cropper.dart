// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pets_social/features/post/controller/post_controller.dart';
// import 'package:pets_social/router.dart';

// class CropImage extends ConsumerStatefulWidget {
//   final String title;
//   final Uint8List? file;
//   final String fileType;
//   final Uint8List thumbnail;
//   final String filePath;
//   const CropImage({super.key, required this.title, required this.file, required this.fileType, required this.thumbnail, required this.filePath});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _CropImageState();
// }

// class _CropImageState extends ConsumerState<CropImage> {
//   CroppedFile? _croppedFile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: _imageCard()),
//         ],
//       ),
//     );
//   }

//   Widget _imageCard() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Card(
//               elevation: 4.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: _image(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24.0),
//           _menu(),
//         ],
//       ),
//     );
//   }

//   Widget _image() {
//     double maxHeight = 550;
//     double maxWidth = MediaQuery.of(context).size.width;
//     double aspectRatioX = maxWidth / maxHeight;
//     double aspectRatioY = 1.0;
//     if (_croppedFile != null) {
//       final path = _croppedFile!.path;
//       return AspectRatio(
//         aspectRatio: aspectRatioX / aspectRatioY,
//         child: Image.file(
//           File(path),
//           fit: BoxFit.fitWidth,
//         ),
//       );
//     } else if (widget.file != null) {
//       final path = widget.filePath;
//       return AspectRatio(
//         aspectRatio: aspectRatioX / aspectRatioY,
//         child: Image.file(
//           File(path),
//           fit: BoxFit.fitWidth,
//         ),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   Widget _menu() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FloatingActionButton(
//           onPressed: () {},
//           backgroundColor: Colors.redAccent,
//           tooltip: 'Delete',
//           child: const Icon(Icons.delete),
//         ),
//         if (_croppedFile != null)
//           FloatingActionButton(
//             onPressed: () {
//               //context.goNamed(AppRouter.confirmPost.name);
//             },
//             backgroundColor: Colors.blue,
//             tooltip: 'Next',
//             child: const Text('Next'),
//           ),
//         if (_croppedFile == null)
//           Padding(
//             padding: const EdgeInsets.only(left: 32.0),
//             child: FloatingActionButton(
//               onPressed: () {
//                 cropImage();
//               },
//               backgroundColor: const Color(0xFFBC764A),
//               tooltip: 'Crop',
//               child: const Icon(Icons.crop),
//             ),
//           )
//       ],
//     );
//   }

//   // Widget _uploaderCard() {
//   //   return Center(
//   //     child: Card(
//   //       elevation: 4.0,
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(16.0),
//   //       ),
//   //       child: SizedBox(
//   //         width: 320.0,
//   //         height: 300.0,
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.max,
//   //           crossAxisAlignment: CrossAxisAlignment.center,
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             Expanded(
//   //               child: Padding(
//   //                 padding: const EdgeInsets.all(16.0),
//   //                 child: DottedBorder(
//   //                   radius: const Radius.circular(12.0),
//   //                   borderType: BorderType.RRect,
//   //                   dashPattern: const [8, 4],
//   //                   color: Theme.of(context).highlightColor.withOpacity(0.4),
//   //                   child: Center(
//   //                     child: Column(
//   //                       mainAxisSize: MainAxisSize.min,
//   //                       crossAxisAlignment: CrossAxisAlignment.center,
//   //                       children: [
//   //                         Icon(
//   //                           Icons.image,
//   //                           color: Theme.of(context).highlightColor,
//   //                           size: 80.0,
//   //                         ),
//   //                         const SizedBox(height: 24.0),
//   //                         Text(
//   //                           'Upload an image to start',
//   //                           style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).highlightColor),
//   //                         )
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //             Padding(
//   //               padding: const EdgeInsets.symmetric(vertical: 24.0),
//   //               child: ElevatedButton(
//   //                 onPressed: () {
//   //                   _uploadImage();
//   //                 },
//   //                 child: const Text('Upload'),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Future<void> cropImage() async {
//     double maxHeight = 550;
//     double maxWidth = MediaQuery.of(context).size.width;
//     double aspectRatioX = maxWidth / maxHeight;
//     double aspectRatioY = 1.0;

//     if (widget.file != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         aspectRatioPresets: [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio16x9],
//         sourcePath: widget.filePath,
//         compressFormat: ImageCompressFormat.jpg,
//         compressQuality: 100,
//         maxHeight: 550,
//         //aspectRatio: CropAspectRatio(ratioX: aspectRatioX, ratioY: aspectRatioY),
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarColor: Colors.pink.shade300,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           IOSUiSettings(
//             title: 'Cropper',
//             aspectRatioLockEnabled: true,
//           ),
//           WebUiSettings(
//             context: context,
//             presentStyle: CropperPresentStyle.dialog,
//             boundary: const CroppieBoundary(
//               width: 520,
//               height: 520,
//             ),
//             viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
//             enableExif: true,
//             enableZoom: true,
//             showZoomer: true,
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         setState(() {
//           _croppedFile = croppedFile;
//           ref.read(newPostProvider.notifier).state = NewPost(
//             file: _croppedFile,
//             fileType: widget.fileType,
//             thumbnail: widget.thumbnail,
//             filePath: widget.filePath,
//           );
//         });
//       }
//     }
//   }

//   // Future<void> _uploadImage() async {
//   //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       widget.file = pickedFile;
//   //     });
//   //   }
//   // }

//   // void _clear() {
//   //   setState(() {
//   //     widget.file = null;
//   //     _croppedFile = null;
//   //   });
//   // }
// }
