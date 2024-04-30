String getFirebaseErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'user-not-found':
      return 'User not found. Please check your email.';
    case 'wrong-password':
      return 'Invalid password. Please try again.';
    case 'email-already-in-use':
      return 'This email is already in use.';
    default:
      return errorCode.toString();
  }
}
