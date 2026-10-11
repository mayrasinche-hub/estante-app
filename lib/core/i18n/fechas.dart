import 'package:get/get.dart';

const _mesesEs = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
const _mesesEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String fechaCorta(DateTime f) {
  if (Get.locale?.languageCode == 'en') {
    return '${_mesesEn[f.month - 1]} ${f.day}, ${f.year}';
  }
  return '${f.day} ${_mesesEs[f.month - 1]} ${f.year}';
}
