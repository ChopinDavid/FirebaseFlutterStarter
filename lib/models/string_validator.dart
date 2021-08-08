class StringValidator {
  static String? isValidPassword(String? password) {
    if (password == null) {
      return 'Please enter a password...';
    }
    bool hasUppercase = RegExp(r"(?=.*[A-Z])").hasMatch(password);
    bool hasSpecial = RegExp(r"(?=.*[!@#$&*])").hasMatch(password);
    bool hasNumber = RegExp(r"(?=.*[0-9])").hasMatch(password);
    bool isLongEnough = password.length >= 8;
    bool passwordValid =
        hasUppercase && hasSpecial && hasNumber && isLongEnough;
    if (password.isEmpty) {
      return 'Please enter a password...';
    } else if (!passwordValid) {
      String errorString = 'Password must have ';
      int errorCount = 0;
      if (!hasUppercase) {
        errorCount++;
      }
      if (!hasSpecial) {
        errorCount++;
      }
      if (!hasNumber) {
        errorCount++;
      }
      if (!isLongEnough) {
        errorCount++;
      }
      final int totalErrorCount = errorCount;

      void addCommaOrAnd() {
        errorCount--;
        if (errorCount == 1) {
          if (totalErrorCount == 2) {
            errorString += ' and ';
          } else {
            errorString += ', and ';
          }
        } else if (errorCount != 0) {
          errorString += ', ';
        }
      }

      if (!hasUppercase) {
        errorString += '1 uppercase character';
        addCommaOrAnd();
      }
      if (!hasSpecial) {
        errorString += '1 special character';
        addCommaOrAnd();
      }
      if (!hasNumber) {
        errorString += '1 number';
        addCommaOrAnd();
      }
      if (!isLongEnough) {
        errorString += 'at least 8 characters';
        addCommaOrAnd();
      }

      errorString += '...';

      return errorString;
    }
    return null;
  }
}
