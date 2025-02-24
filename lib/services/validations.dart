String? validateName(String? value) {
  if (value!.isEmpty) {
    return "value is required";
  }
  if (value.toString().length < 3) {
    return "value must greater than 3 char";
  }
  Pattern pattern = r'^[a-zA-Z ]*$';
  RegExp regExp = RegExp(pattern.toString());
  if (!regExp.hasMatch(value.toString())) {
    return "Name should contain only chars. and space";
  }
  return null;
}

String? validateAge(String? value) {
  if (value!.isEmpty) {
    return "value is required";
  }
  Pattern pattern = r'^[0-9]*$';
  RegExp regExp = RegExp(pattern.toString());
  if (!regExp.hasMatch(value.toString())) {
    return "age should be in digits";
  }

  return null;
}

String? validateCell(String? value) {
  if (value!.isEmpty) {
    return "value is required";
  }
  if (value.toString().length < 11) {
    return "no. of 11 char digits required";
  }

  Pattern pattern = r'^03\d{9}$';
  RegExp regExp = RegExp(pattern.toString());
  if (!regExp.hasMatch(value.toString())) {
    return "number of pattern 03XXXXXXXXX required";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return "value is required";
  }
  Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regExp = RegExp(pattern.toString());
  if (!regExp.hasMatch(value.toString())) {
    return "enter valid email";
  }
  return null;
}

String? validatePass(String? value) {
  Pattern pattern = r'\d{8}$';
  RegExp regExp = RegExp(pattern.toString());

  if (!regExp.hasMatch(value.toString())) {
    return 'only 8 char. digit XXXXXXXX required';
  }

  return null;
}

String? validateText(String? value) {
  if (value.toString().isEmpty) {
    return "Enter Text";
  }
  if (value.toString().length < 3) {
    return "Minimum 3 char. required";
  }

  return null;
}
