class StringConstants {
  StringConstants._();

  static const String regExp =
      r"^(?=.{1,320}$)[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$";
  static const String emptyEmailValidation = "Please enter your email address";
  static const String wrongEmailValidation = "Please enter a valid email address";
  static const String enterPassword = "Password";
  static const String enterConfirmPassword = "Confirm password";
  static const String emailAddress = "Email Address";
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String mobileNumber = "Mobile Number";
  static const String emptyPasswordValidation = "Enter password";
  static const String emptyConfPasswordValidation = "Enter confirm password";
  static const String passwordValidationError =
      "Password must be 8 character with number, symbol, capital and small letter";
  static const String passwordRequired = "Please enter your password.";
  static const String passwordMinLength = "Password must be at least 8 characters long.";
  static const String passwordMissingLowercase =
      "Password must contain at least one lowercase letter.";
  static const String passwordMissingUppercase =
      "Password must contain at least one uppercase letter.";
  static const String passwordMissingSpecialChar =
      "Password must contain at least one special character.";
  static const String emptyFirstName = 'Please enter first name';
  static const String emptyLastName = 'Please enter last name';
  static const String emptyMobileNumber = 'Please enter mobile number';
  static const String firstNameRequired = "Please enter your first name.";
  static const String firstNameInvalidChars = "First name can only contain letters.";
  static const String lastNameRequired = "Please enter your last name.";
  static const String lastNameInvalidChars = "Last name can only contain letters.";
  static const String confirmPasswordRequired = "Please confirm your password.";
  static const String confirmPasswordMismatch = "Password does not match.";
  static const String mobileNumberRequired = "Please enter your mobile number.";
  static const String mobileNumberMinLength = "Mobile number must be at least 7 digits.";
  static const String mobileNumberInvalidFormat = "Please enter a valid mobile number.";
}
