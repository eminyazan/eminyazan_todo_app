class ErrorManager {
  static String show(String errCode) {
    switch (errCode) {
      case 'invalid-email':
        return "Your mail address is invalid";
      case 'emaıl-already-ın-use':
        return 'This email already in use';
      case 'wrong-password':
        return 'Your password is wrong';
      case 'user-not-found':
        return 'User not found try to register';
      case 'operation-not-allowed':
        return "This operation isn't allowed";
      case 'weak-password':
        return 'Your password is too weak';
      case 'user-not-verified':
        return 'User is not verified';
      case 'network-request-failed':
        return 'We facing problem with your network connection';
      default:
        return 'Sorry! unexpected error occurred';
    }
  }
}
