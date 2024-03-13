import 'package:cloud_firestore/cloud_firestore.dart';

class ModelReport {
  final String reportType;
  final String reportId;
  final String reportedProfile;
  final String? reportedPostId;
  final String summary;
  final DateTime datePublished;

  const ModelReport({
    required this.reportType,
    required this.reportId,
    required this.reportedProfile,
    this.reportedPostId,
    required this.summary,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "reportType": reportType,
        "reportId": reportId,
        "reportedProfile": reportedProfile,
        "reportedPostId": reportedPostId ?? '',
        "summary": summary,
        "datePublished": datePublished,
      };

  static ModelReport fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelReport(
      reportType: snapshot['reportType'],
      reportId: snapshot['reportId'],
      reportedProfile: snapshot['reportedProfile'],
      reportedPostId: snapshot['reportedPostId'],
      summary: snapshot['summary'],
      datePublished: snapshot['datePublished'],
    );
  }
}
