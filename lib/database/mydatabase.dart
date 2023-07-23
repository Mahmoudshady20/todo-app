import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/model/myuser.dart';

class MyDataBase {
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (myUser, options) => myUser.toFireStore(),
        );
  }
  static Future<void> addUser(MyUser myUser){
    CollectionReference<MyUser> collection = getUserCollection();
    return collection.doc(myUser.id).set(myUser);
  }
  static Future<MyUser?> readUser(String? uid) async{
    CollectionReference<MyUser> collection = getUserCollection();
    var docSnapShot = await collection.doc(uid).get();
    return docSnapShot.data();
  }
}
