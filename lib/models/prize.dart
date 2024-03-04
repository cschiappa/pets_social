import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPrize {
  final String type;
  final String iconActivated;
  final String iconDeactivated;
  final bool isPaid;
  final int price;

  const ModelPrize({
    required this.type,
    required this.iconActivated,
    required this.iconDeactivated,
    required this.isPaid,
    required this.price,
  });

  ModelPrize copyWith({
    String? type,
    String? iconActivated,
    String? iconDeactivated,
    bool? isPaid,
    int? price,
  }) {
    return ModelPrize(
      type: type ?? this.type,
      iconActivated: iconActivated ?? this.iconActivated,
      iconDeactivated: iconDeactivated ?? this.iconDeactivated,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "iconActivated": iconActivated,
        "iconDeactivated": iconDeactivated,
        "isPaid": isPaid,
        "price": price,
      };

  static ModelPrize fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelPrize(
      type: snapshot['type'],
      iconActivated: snapshot['iconActivated'],
      iconDeactivated: snapshot['iconDeactivated'],
      isPaid: snapshot['isPaid'],
      price: snapshot['price'],
    );
  }
}
