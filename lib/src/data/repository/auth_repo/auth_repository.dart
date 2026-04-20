import 'package:cosmospedia/src/data/model/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth; //= FirebaseAuth.instance;
  final FirebaseFirestore _firestore; //= FirebaseFirestore.instance;

  // Constructor jo instances accept karta hai
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth, _firestore = firestore;

  // Sign Up Logic
  Future<void> signUp(UserModel user, String password) async {
    try {
      // 1. Auth mein account create karo
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final String actualUid = credential.user!.uid;
      final userData = user.toMap();
      userData['uid'] = actualUid; // Empty string ko asli UID se overwrite kar diya

      // 2. Firestore mein user details save karo
      // Hum wahi UID use karenge jo Auth ne generate ki hai
      await _firestore.collection('users').doc(actualUid).set(userData);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An unknown error occurred";
    }
  }

  // Sign In Logic
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Invalid Credentials";
    }
  }

  // Forgot Password logic
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Error sending reset email";
    }
  }

  // AuthRepository.dart ke andar ye add karein

// 1. Current User ka data Firestore se fetch karna
  Future<UserModel> getUserProfile() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw "User not found";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // 2. Name ya Designation update karna
  Future<void> updateProfileField(String field, String value) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({field: value});
    } catch (e) {
      throw e.toString();
    }
  }

  // 3. Password Change (Firebase Auth level par)
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      throw e.toString();
    }
  }

  // sign out logic
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw "Logout failed: ${e.toString()}";
    }
  }

}