import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/firebase_errors.dart';
import 'package:pets_social/core/utils/utils.dart';

extension AsyncValueUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final dynamic error = this.error;
      String errorMessage = error.toString();

      if (error is FirebaseException) {
        errorMessage = getFirebaseErrorMessage(error.code);
      }

      showSnackBar(errorMessage.toString(), context);
    }
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    var renderObject = currentContext?.findRenderObject();
    var matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      var rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}
