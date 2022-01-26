import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../bases/user_base.dart';

class Database{
  final _fireStore=FirebaseFirestore.instance;
  DocumentSnapshot<Map<String, dynamic>>? _documentSnapshot;
  MyUser? _myUser;


  Future<MyUser?>readUserDB(String uid) async{
    try{
      _documentSnapshot=await _fireStore.collection("users").doc(uid).get();
      _myUser=MyUser.fromMap(_documentSnapshot!.data());
      return _myUser;
    }on FirebaseException catch(e){
      debugPrint("Error occurred in read user db --> ${e.code}  ${e.message}");
      return null;
    }
  }

  Future<bool?>writeUserDB(MyUser myUser) async{
    try{
      await _fireStore.collection("users").doc(myUser.uid).set(myUser.toMap());
      return true;
    }on FirebaseException catch(e){
      debugPrint("Error occurred in write user db --> ${e.code}  ${e.message}");
      return null;
    }
  }

}