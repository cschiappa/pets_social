import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

//Upload Image
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    var filePath = file.path;
    final fileExtension = p.extension(filePath) != '' ? p.extension(filePath) : file.mimeType;
    final fileBytes = await file.readAsBytes();

    final thumbnail = fileBytes;
    return (fileBytes, fileExtension, thumbnail, filePath);
  }
  debugPrint('No image selected');
}

//Upload Video
pickVideo(ImageSource source) async {
  final ImagePicker videoPicker = ImagePicker();

  XFile? file = await videoPicker.pickVideo(source: source, maxDuration: const Duration(minutes: 10));

  if (file != null) {
    var filePath = file.path;
    final fileExtension = p.extension(filePath) != '' ? p.extension(filePath) : file.mimeType;
    final fileBytes = await file.readAsBytes();

    final thumbnail = await VideoThumbnail.thumbnailData(
      video: filePath,
      quality: 25,
      imageFormat: ImageFormat.JPEG,
    );

    return (fileBytes, fileExtension, thumbnail, filePath);
  }
  debugPrint('No video selected');
}

//PASSWORD CHECKER
bool isPasswordValid(String password) {
  const lengthRequirement = 5;
  final uppercaseRegex = RegExp(r'[A-Z]');
  final lowercaseRegex = RegExp(r'[a-z]');
  final numberRegex = RegExp(r'[0-9]');
  final specialCharacterRegex = RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]');

  if (password.length < lengthRequirement || !uppercaseRegex.hasMatch(password) || !lowercaseRegex.hasMatch(password) || !numberRegex.hasMatch(password) || !specialCharacterRegex.hasMatch(password)) {
    return false;
  }

  return true;
}

//Determine if file is an image or video
String getContentTypeFromUrl(fileType) {
  // Check if the URL ends with a known image file extension
  final imageExtensions = [
    'jpg',
    'jpeg',
    'jpe',
    'png',
    'gif',
    'bmp',
    'webp',
    'jfif',
    'svg',
  ];
  if (fileType != null) {
    if (imageExtensions.contains(fileType.contains('/') ? fileType.split('/')[1] : fileType.split('.')[1])) {
      return 'image';
    }

    // Check if the URL ends with a known video file extension
    final videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'webm', 'gif'];

    if (videoExtensions.contains(fileType.contains('/') ? fileType.split('/')[1] : fileType.split('.')[1])) {
      return 'video';
    }
  }
  // If no match is found
  return 'unknown';
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String cropMessage(String message, int maxLetters) {
  if (message.length <= maxLetters) {
    return message;
  } else {
    return '${message.substring(0, maxLetters)}...';
  }
}

int parseStringToInt(String value) {
  return int.tryParse(value) ?? 0;
}

class ImageCropperCustom extends ImageCropper {
  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> aspectRatioPresets = const [CropAspectRatioPreset.original, CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) {
    return ImageCropper.platform.cropImage(
      sourcePath: sourcePath,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      aspectRatioPresets: aspectRatioPresets,
      cropStyle: cropStyle,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      uiSettings: uiSettings,
    );
  }
}

//START OF WORD WITH UPPER CASE ONLY FORMATTER
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

//NO SPACES FORMATTER
class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains any spaces
    if (newValue.text.contains(' ')) {
      // If it does, return the old value
      return oldValue;
    }
    // Otherwise, return the new value
    return newValue;
  }
}
