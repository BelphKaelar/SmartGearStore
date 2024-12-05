import 'package:smartgear_store/consts/consts.dart';

class FirestoreServices {
  //Get user data
  static getUser(uid) {
    return firestore
        .collection(userCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //Get products according to category
  static getProduct(category) {
    return firestore
        .collection(productCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }
}
