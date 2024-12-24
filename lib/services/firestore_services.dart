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

  //Get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //Delete
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static getAllOrders() {
    return firestore
        .collection(orderCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishList() {
    return firestore
        .collection(productCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(orderCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      })
    ]);
    return res;
  }

  static allProducts() {
    return firestore.collection(productCollection).snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection(productCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  static searachProduct(title) {
    return firestore.collection(productCollection).get();
  }
}
