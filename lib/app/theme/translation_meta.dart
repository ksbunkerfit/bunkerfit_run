import 'package:get/get.dart';

class TranslationMeta extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
        },
        'hi_IN': {
          'hello': 'नमस्कार',
        }
      };
}

// Text("hello".tr,);
