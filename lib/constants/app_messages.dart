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
        return "No account was found matching the username and password";
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
        return "Email address is invalid.";
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
      case "PRODUCT_LOOKING_SAVED":
        return "The product you are looking for has been posted.";
      default:
        return "SUCCESS!";
    }
  }
}
