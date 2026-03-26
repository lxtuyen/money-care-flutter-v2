class AppValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required.";
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) return 'Invalid email address.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter.';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least 1 lowercase letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 digit.';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least 1 special character.';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }
    if (confirmPassword != password) return 'Passwords do not match.';
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required.';
    final phoneRegExp = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegExp.hasMatch(value)) return 'Invalid phone number.';
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã OTP.';
    }
    if (!RegExp(r'^[0-9]{4,6}$').hasMatch(value)) {
      return 'OTP phải gồm 4–6 số.';
    }
    return null;
  }


  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) return "First name is required.";
    final nameRegExp = RegExp(r"^[a-zA-ZÀ-ỹ\s]+$");
    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid first name (letters only).';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) return "Last name is required.";
    final nameRegExp = RegExp(r"^[a-zA-ZÀ-ỹ\s]+$");
    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid last name (letters only).';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên.';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập địa chỉ.";
    }
    if (value.length < 5) return "Địa chỉ quá ngắn.";
    return null;
  }

  static String? validateNote(String? value) {
    if (value != null && value.length > 200) {
      return 'Ghi chú quá dài (tối đa 200 kí tự).';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số tiền';
    }

    final numVal = double.tryParse(value.replaceAll(',', '').replaceAll('.', ''));

    if (numVal == null) return 'Số tiền không hợp lệ';
    if (numVal <= 0) return 'Số tiền phải lớn hơn 0';
    if (numVal > 100000000000) return 'Số tiền quá lớn';

    return null;
  }

  static String? validatePercentage(String? value) {
    if (value == null || value.isEmpty) return 'Nhập %';
    final numVal = int.tryParse(value);
    if (numVal == null || numVal < 0 || numVal > 100) {
      return 'Phải từ 0–100';
    }
    return null;
  }

  static String? validateMonthlyIncome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập thu nhập hàng tháng';
    }

      final numVal = double.tryParse(
        value.replaceAll(',', '').replaceAll('.', ''),
      );

    if (numVal == null) return 'Thu nhập phải là số hợp lệ';
    if (numVal <= 0) return 'Thu nhập phải lớn hơn 0';
    if (numVal > 1000000000) {
      return 'Thu nhập quá lớn (giới hạn 1,000,000,000)';
    }

    return null;
  }

  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số';
    if (int.tryParse(value) == null) return 'Phải là số nguyên';
    return null;
  }

  static String? validateDouble(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số';
    if (double.tryParse(value) == null) return 'Phải là số hợp lệ';
    return null;
  }

  static String? validateTransactionDate(DateTime? date) {
    if (date == null) return 'Vui lòng chọn ngày giao dịch.';
    if (date.isAfter(DateTime.now())) {
      return 'Ngày giao dịch không thể ở tương lai.';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng chọn phân loại';
    }
    return null;
  }
}
