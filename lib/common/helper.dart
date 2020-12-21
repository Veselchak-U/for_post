import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:for_post/import.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final DateFormat dateTimeformatter = DateFormat('dd.MM.yyyy HH:mm');

void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}

void errorSnackbar(dynamic error) {
  Get.snackbar(
    'Error',
    '$error',
    duration: Duration(seconds: 5),
    onTap: (GetBar<Object> bar) => Get.back(),
  );
}

ImageProvider<Object> getNetworkOrAssetImage(
    {String url, String asset = '${kAssetPath}placeholder_banner.jpg'}) {
  ImageProvider<Object> result = AssetImage(asset);

  if (url != null && url.isNotEmpty) {
    try {
      var networkImage = NetworkImage(url);
      result = networkImage;
    } on Exception {
      out('ERRRR');
    }
  }
  return result;
}
