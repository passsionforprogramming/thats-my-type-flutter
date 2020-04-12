validEmail({String email}) {
  final String pattern =
      r'(^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$)';
  final RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}
