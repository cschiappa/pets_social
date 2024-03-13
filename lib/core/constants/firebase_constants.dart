class FirestorePath {
  //USERS COLLECTION
  static String user(String uid) => 'users/$uid';
  static String profile(String uid, String profileUid) => 'users/$uid/profiles/$profileUid';
  //POSTS COLLECTION
  static String post(String postId) => 'posts/$postId';
  static String comment(String postId, String commentId) => 'posts/$postId/comments/$commentId';
  //NOTIFICATIONS COLLECTION
  static String notification(String notificationId) => 'notifications/$notificationId';
  //FEEDBACK COLLECTION
  static String feedback(String feedbackId) => 'feedback/$feedbackId';
  //REPORT COLLECTION
  static String reports(String reportType, String reportId) => 'reports/$reportType/reports/$reportId';
  //CHATS COLLECTION
  static String chat(String chatId) => 'chats/$chatId';
  static String message(String chatId, String messageId) => 'chats/$chatId/messages/$messageId';
  //PET TAGS
  static String petTags(String petTag) => 'pet-tags/$petTag';
}
