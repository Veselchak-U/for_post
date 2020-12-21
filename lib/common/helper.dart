import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final DateFormat dateTimeformatter = DateFormat('dd.MM.yy HH:mm');

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
