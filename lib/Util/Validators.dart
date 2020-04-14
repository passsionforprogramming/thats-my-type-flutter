import 'package:phone_number/phone_number.dart';

validEmail({String email}) {
  final String pattern =
      r'(^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$)';
  final RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}

Future<bool> validatePhone({String number, String country}) async {
  PhoneNumber plugin = PhoneNumber();
  try {
    final parsed = await plugin.parse(number, region: country);
    print("Here is the parsed $parsed");
    if (parsed != null) return true;
    return false;
  } catch (e) {
    return false;
  }
}
