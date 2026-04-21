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
      final userData = user.toMap(); // convert model data to map
      userData['uid'] = actualUid; // Empty string ko asli UID se overwrite kar diya


      //await _firestore.collection('users').doc(actualUid).set(userData); // earlier only this line now this line with try catch

      // yeh try catch uske liye ki agr user create ho gaya lekin firestore m uski details store karte vakt internet chala gaya ya kuch aur error aayi tab auth m toh user create ho gaya lekin firestore m nahi hua toh jab user phir se usi cred ke saath sign up karega toh error aayegi leki uss uid se jab data firestore se fetch karega toh khali aayega.
      try {
        // User creation logic...
        // 2. Firestore mein user details save karo manually mtlb jab user create ho jaye tab user ki uss id ko use karke user ka jo bhi data tumhe firestore(db) m store karna h voh karo . toh uske liye firestore m ek collection banao tum users ke naam se phir uss collection m uss user ki uid ke naam se ek doc bano and end m jo bhi data uss document m daalna h voh daal(set kar) do.
        // Hum wahi UID use karenge jo Auth ne generate ki hai
        await _firestore.collection('users').doc(actualUid).set(userData);// users collection developer create kar raha h phir user ki UID ke naam se ek folder (Document) bana raha h aur ye sara data usme bhar de raha h."
      } catch (e) {
        // AGAR Firestore fail hua, toh Auth wala user delete kar do
        await _auth.currentUser?.delete();
        throw e.toString();
      }

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