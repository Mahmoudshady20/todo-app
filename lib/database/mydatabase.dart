import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/model/myuser.dart';
import 'package:todo/database/model/task.dart';

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

  static Future<void> addUser(MyUser myUser) {
    CollectionReference<MyUser> collection = getUserCollection();
    return collection.doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUser(String? uid) async {
    CollectionReference<MyUser> collection = getUserCollection();
    var docSnapShot = await collection.doc(uid).get();
    return docSnapShot.data();
  }

  static CollectionReference<Task> getTaskCollection(String? uid) {
    return getUserCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }
  static Future<void> addTask(String? uid,Task task){
    var collection = getTaskCollection(uid).doc();
    task.id = collection.id;
    return collection.set(task);
  }
  static Stream<QuerySnapshot<Task>> getTask(String? uid,int date){
    CollectionReference<Task> collection = getTaskCollection(uid);
    return collection.where('date',isEqualTo: date).snapshots();
  }
  static Future<void> deleteTask(String? uid,Task task){
    CollectionReference<Task> collection = getTaskCollection(uid);
    return collection.doc(task.id).delete();
  }
  static updateTask(String? uid,Task task){
    CollectionReference<Task> collection = getTaskCollection(uid);
    return collection.doc(task.id).update(task.toFireStore());
  }
}
