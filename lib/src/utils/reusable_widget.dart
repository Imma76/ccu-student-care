import 'package:bot_toast/bot_toast.dart';

void showToast(message, {duration = const Duration(seconds: 3)}) =>
    BotToast.showText(
      text: message,
      duration: duration,
    );