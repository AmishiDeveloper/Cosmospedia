import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmospedia/src/data/model/user_model/user_model.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';

/*
* SIGN-IN PROCESS FIREBASE:-
* 1. User enters email & password
2. Flutter sends request to Firebase Auth
3. Firebase checks:
   - Email exists? IF NO SEND ERROR AS RESPONSE (4.) . IF YES CHECK PWD
   - Password correct? IF NO SEND ERROR AS RESPONSE (4.) IF YES (5.)
4. If failed → error returned
5. If success:
   - User is authenticated
   - Token generated (internally) this authenticates user
   - User object returned (ONLY USER OBJECT IS RETURNED token is invisible)
   * User object contains:-
   * UserCredential {
   user: User,
   credential: AuthCredential (kabhi kabhi null),
}  jisme
*  uid - unique id of user
*  email- user email
* emailVerified- verified or not(T/F)
* displayName- user name
* photoURL- profile photo
* phoneNumber- if phone login used
* providerData- kis method se login kiya (email/pwd or google or phone)
* metadata- account info (when created, last login )
* * displayName- user name
* photoURL- profile photo
* phoneNumber- if phone login used. note- yeh teen cheeze optional hoti h depending kisse login kiya h toh agr nahi koi value aayi toh default value set hoti h
6. Flutter:
   - Handles response
   - Navigates user to home screen

*/

/* SIGN-UP PROCESS FIREBASE:-

*User Input

Flutter App sends input to

Firebase Auth Server checks

Email (if email is already existing in data base or not ) if yes sends error as
 response as already in use if not already in use then

 Validate Password ( checks min length i.e 6.) if not fulfiiled returns error of
 weak pwd as response if pwd validated

Creates User (in auth) (creating user generates unique UID for user + now developer using code stores data in firestore by creating the collection named users and then creating a doc with users uid and finally storing all user data in that document)

Generates Token (goes internally so not visible ) that authenticates user

Send User Object as response

Flutter handles UI
since token is generated so user was created user in auth using sign up then using this tocken also validated means signed in
goes to home screen

*/



// 1. Nakli Classes (Mocks)
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}




void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDoc;
  late MockDocumentSnapshot mockDocSnapshot;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDoc = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();
    // Repository ko nakli instances ke sath initialize kiya
    authRepository = AuthRepository(auth: mockAuth, firestore: mockFirestore);

    registerFallbackValue(mockDoc);
    registerFallbackValue(mockDocSnapshot);
  });

  group('AuthRepository Tests', () {

    ///SIGN IN TEST

    /// --- SIGN IN Success TEST ---
    test('signIn call successfully calls firebase method', () async {
      final mockCredential = MockUserCredential();

      // Arrange: Firebase ko bolo ki jab login ho toh success return kare
      when(() => mockAuth.signInWithEmailAndPassword(
        email: 'test@gmail.com',
        password: 'Password@123',
      )).thenAnswer((_) async => mockCredential);

      // Act: Repository ka function call karo
      await authRepository.signIn('test@gmail.com', 'Password@123');

      // Assert: Check karo ki kya Firebase ka method 1 baar call hua
      verify(() => mockAuth.signInWithEmailAndPassword(
        email: 'test@gmail.com',
        password: 'Password@123',
      )).called(1);
    });

    ///--SIGN IN ERROR TEST
    test('signIn throws an error message when firebase login fails', () async {
      // 1. Arrange: Mock ko bolo ki Error (Exception) throw kare
      when(() => mockAuth.signInWithEmailAndPassword(
        email: 'wrong@gmail.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'User not found'));

      // 2. Act
      // Hum expect kar rahe hain ki ye function "User not found" wala error dega
      expect(
            () => authRepository.signIn('wrong@gmail.com', 'wrongpassword'),
        throwsA('User not found'), // Aapne repo mein throw e.message kiya hai, toh ye wahi check karega
      );

      //3. Assert:
      // Ye bhi check karo ki kya call hua tha?
      verify(() => mockAuth.signInWithEmailAndPassword(
        email: 'wrong@gmail.com',
        password: 'wrongpassword',
      )).called(1);
    });

    ///----------------SIGN UP

    /// SIGN UP SUCCESS TEST
    test('signUp creates user in Auth and saves in Firestore', () async {
      final UserModel tUser = UserModel(email: 'test@gmail.com', name: 'Test User', designation: 'General Public', uid: '');
      final MockUserCredential mockCredential = MockUserCredential();
      final MockUser mockUser = MockUser();


      // Arrange:

      // 1. Mocking UID behavior
      // jab hum when(() => mockUser.uid) aisa kuch mange ge toh hum ek id milegi
      when(() => mockUser.uid).thenReturn('Zxs2dg25sXGgfh12345');
      when(() => mockCredential.user).thenReturn(mockUser);

      // 2. Auth mock (user creation in auth)
      when(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).thenAnswer((_) async => mockCredential);

      // 3. Firestore mock (Chaining: collection -> doc -> set)(user store in firestore)
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);//jab mera code iss users collection ko dhundhne aaye toh use fake collection de dena
      when(() => mockCollection.doc('Zxs2dg25sXGgfh12345')).thenReturn(mockDoc);// jab code iss nakli collection ke iss id vale doc ko maange tab use fake doc de dena
      when(() => mockDoc.set(any())).thenAnswer((_) async => {});//Uss mock doc (Document) m yeh sara data save kar do. toh hum aisa dikhayenge ki hogya lekin actually kuch nahi hua h"

      // Act
      await authRepository.signUp(tUser, 'Password@123');

      // Assert: Verify Auth creation
      verify(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).called(1);

      // Verify Firestore saving
      verify(() => mockDoc.set(any())).called(1);
    });


    /// SIGN UP ERROR TEST
    // Ya toh Firebase Auth mana kar de (Email already exists, etc.)
    // Ya Firestore mein data save karte waqt internet chala jaye.
    test('signUp throws error and DOES NOT call firestore when Auth fails', () async {
      final tUser = UserModel(email: 'test@gmail.com', name: 'Test User', designation: 'General Public', uid: '');

      // 1. Arrange: Auth ko bolo ki error phenke
      when(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use', message: 'Email already exists'));

      // 2. Act
      expect(
            () => authRepository.signUp(tUser, 'Password@123'),
        throwsA('Email already exists'),
      );

      //3. Assert
      // Verification: Check karo ki Auth call hua
      verify(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).called(1);

      // Sabse important: Check karo ki Firestore ko hath bhi nahi lagaya (verifyNever)
      verifyNever(() => mockFirestore.collection('users'));
    });

    test('signUp should delete Auth user if Firestore saving fails (Rollback)', () async {
      final tUser = UserModel(email: 'test@gmail.com', name: 'Test User', designation: 'General Public', uid: '');
      final mockCredential = MockUserCredential();
      final mockUser = MockUser();


      // --- 1. Arrange (Acting Setup) ---

      // Auth Success setup
      when(() => mockUser.uid).thenReturn('Zxs2dg25sXGgfh12345');
      when(() => mockCredential.user).thenReturn(mockUser);

      when(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).thenAnswer((_) async => mockCredential);

      // Firestore Failure setup
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenThrow('Firestore Error');

      // Rollback (Delete) setup
      // Humne bola ki jab delete() call ho toh khamoshi se success maan lena
      when(() => mockAuth.currentUser).thenReturn(mockUser); // Rollback ke liye zaroori
      when(() => mockUser.delete()).thenAnswer((_) async => {});



      // --- 2. Act (Action) ---

      // Hum expect kar rahe hain ki ye function error phekega
      try {
        await authRepository.signUp(tUser, 'Password@123');
      }
      catch (e) {

      }

      // --- 3. Assert (Verification) ---

      verify(() => mockAuth.createUserWithEmailAndPassword(
        email: tUser.email,
        password: 'Password@123',
      )).called(1);

      // Check karo ki Firestore mein save karne ki koshish hui thi
      verify(() => mockDoc.set(any())).called(1);

      // Sabse Important: Check karo ki kya rollback (delete) function call hua?
      verify(() => mockUser.delete()).called(1);
    });


    /// USER ACCOUNT SUCCESS TEST
    test('getUserProfile returns UserModel when document exists', () async {
      final mockUser = MockUser();
      final userData = {'uid': '123', 'name': 'Amishi', 'email': 'test@gmail.com'};

      // Arrange
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('123');

      // Firestore chain setup
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);

      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockDocSnapshot);

      // Mocking the snapshot data
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(userData);

      // Act
      final result = await authRepository.getUserProfile();

      // Assert
      expect(result.name, 'Amishi');
      expect(result.email, 'test@gmail.com');
      // Type check: Pakka karo ki ye UserModel hi hai
      expect(result, isA<UserModel>());
    });


    /// USER ACCOUNT ERROR TEST
    test('getUserProfile throws "User not found" when document does not exist', () async {
      // 1. Setup mocks
      final mockUser = MockUser();

      // 2. Arrange (Acting Script)
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('123');

      // Firestore path setup
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.get()).thenAnswer((_) async => mockDocSnapshot);

      // Snapshot ko acting karni h ki: "Bolna ki data NAHI hai"
      when(() => mockDocSnapshot.exists).thenReturn(false);

      // 3. Act  (Check failure)
      // Hum expect kar rahe hain ki ye function "User not found" wala error phekega
      expect(
            () => authRepository.getUserProfile(),
        throwsA('User not found'),
      );

      //4. Assert
      // Verify karo ki Firestore tak baat pahunchi thi
      verify(() => mockFirestore.collection('users').doc(any()).get()).called(1);
    });

  });

}