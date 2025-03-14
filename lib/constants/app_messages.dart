class AppMessage {
  String code = '';

  AppMessage(this.code);

  static getError(code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Invalid email or password.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No account was found matching the email address and password";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      // case "operation-not-allowed":
      //   return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Invalid Email Address.";
      case "EMAIL_NOT_FOUND":
        return "Email Address not found.";
      case "ERROR_IMAGE_FAILED":
        return "Failed to fetch your image.";
      case "ERROR_FILE_FAILED":
        return "Failed to fetch your file.";
      case "UPLOAD_FAILED":
        return "An error occurred while uploading your photo.";
      case "TERMS_REQUIRED":
        return "Please agree to the terms first.";
      case "FORM_INVALID":
        return "Please complete the form to continue.";
      case "SESSION_EXPIRED":
        return "Your session has expired.";
      default:
        return "Login failed. Please try again.";
    }
  }

  static getSuccess(code) {
    switch (code) {
      case "LOGIN_SUCCESS":
        return "Please wait while we are fetching your account.";
      case "LOGOUT_SUCCESS":
        return "You have been successfully logged out.";
      case "REGISTER_SUCCESS":
        return "Your account has been created successfully.";
      case "PROFILE_UPDATE":
        return "Your account has been updated.";
      case "PRODUCT_LOOKING_SAVED":
        return "The product you are looking for has been posted.";
      case "FEEDBACK_SAVE":
        return "Your feedback has been successfully sent.";
      case "COMPLAINT_SAVE":
        return "Your complaint has been successfully sent.";
      case "PASSWORD_RESET":
        return "Your password has been updated.";
      case "EMAIL_SENT":
        return "An email has been sent to your registered email address.";
      case "INTERESTED":
        return "Interest successfully saved.";
      default:
        return "SUCCESS!";
    }
  }
}
