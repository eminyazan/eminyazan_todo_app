
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../bases/user_base.dart';
import '../consts/consts.dart';
import '../db/database.dart';
class AuthService extends GetxController {
  Database _database = Database();

  MyUser? _myUser;
  Box<MyUser> _authBox = Hive.box<MyUser>(LOCALDB);

  RxBool _authenticated = false.obs;

  final _firebaseAuth = FirebaseAuth.instance;

  Future<MyUser?> registerWithEmail(String email, password) async {
    UserCredential _credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    MyUser _registerMyUser = MyUser(email: email, uid: _credential.user!.uid);
    bool? _isCreated = await _database.writeUserDB(_registerMyUser);
    if (_isCreated == true) {
      _myUser = await _credentialConverter(_credential);
      if (_myUser != null) {
        await _authBox.put(LOCALDB, _myUser!);
        _authenticated.value = true;
        return _myUser;
      } else {
        _authenticated.value = false;
        return null;
      }
    } else {
      return null;
    }
  }

  Future<MyUser?> loginWithEmail(String email, password) async {
    UserCredential _credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    _myUser = await _credentialConverter(_credential);
    if (_myUser != null) {
      await _authBox.put(LOCALDB, _myUser!);
      _authenticated.value = true;
      return _myUser;
    } else {
      _authenticated.value = false;
      return null;
    }
  }

  Future<MyUser?> _credentialConverter(UserCredential credential) async {
    _myUser = await _database.readUserDB(credential.user!.uid);
    return _myUser;
  }

  Future<bool?> logOut() async {
    try{
      await _firebaseAuth.signOut();
      await _authBox.clear();
    }on FirebaseAuthException catch(e){
      return null;
    }
  }

  Future<void> sendPasswordReset(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
