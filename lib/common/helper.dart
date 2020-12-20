import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final DateFormat dateTimeformatter = DateFormat('dd.MM.yyyy HH:mm');

void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}
