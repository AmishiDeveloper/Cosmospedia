/*Testing Engine), ek naya SignInCubit banao. Is Cubit ko bol do ki jab ye login karne jaye, toh hamari MockRepo use kare. Aur MockRepo ko maine samjha diya hai ki jaise hi test@gmail.com aur Password@123 aaye, bina kisi deri ke Success (Future) return kar dena. Ye lo tumhara taiyar Cubit, ab ispe test shuru karo!"*/

import 'package:bloc_test/bloc_test.dart';// Bloc/Cubit test karne ke liye special tools deta hai.
import 'package:cosmospedia/src/logic/cubits/auth/sign_in_cubit/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';//// Nakli (Mock) objects banane ki library.
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';

// 1. AuthRepository ka nakli version (Mock)
class MockAuthRepository extends Mock implements AuthRepository {} //extends mock matlb ki class nakli acting karegi.implements AuthRepository: Ye computer ko batata hai ki MockAuthRepository ke paas wo saare functions (signIn, signUp) honge jo asli AuthRepository ke paas hain.

void main() {
  // late because abhi value nahi di h par inn variables ko use karne se phele mein inn values ko variables ko provide kar dunga.
  late SignInCubit signInCubit;// cubit jise hume test karna h
  late MockAuthRepository mockAuthRepository;// Nakli Repo jo Cubit ko denge.

  setUp(() {  // testing se phele ki tyaari
    // Mock setup
    mockAuthRepository = MockAuthRepository();// creating naki repo obj

    // GetIt ko reset karna zaroori hai kyunki Cubit GetIt se repo utha raha hai
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();//Agar getIt mein pehle se koi Repository hai, toh use hata do. Kyun? Taaki purana test naye test ko disturb na kare.
    }
    getIt.registerSingleton<AuthRepository>(mockAuthRepository); // ab nakli vali mock repo ko register karna aur jab koi maange toh yahi dena

    signInCubit = SignInCubit();// Cubit initialize kiya. Cubit ne andar hi andar getIt se nakli repo utha li.
  });

  tearDown(() {
    signInCubit.close();//// Test khatam hone ke baad Cubit ko band karna zaroori hai memory bachane ke liye.
  });

  group('SignInCubit Tests', () {

    // --- Test 1: Success Case ---
    blocTest<SignInCubit, SignInState>(
      'emits [Loading, Success] when signIn is successful',// Test ka naam.

      // A: Setup
      build: () {
        // Arrange: Repository ko bolo success return kare
        when(() => mockAuthRepository.signIn('test@gmail.com', 'Password@123'))
            .thenAnswer((_) async => {});// Acting script: "Agar ye email/pwd aaye toh Success bol dena."
        return signInCubit;// Taiyar Cubit engine ko wapas kiya.
      },

      // B: Action
      act: (cubit) => cubit.signIn(email: 'test@gmail.com', password: 'Password@123'),//Cubit ka wo function call kiya jo humein test karna hai.

      //C: Result Check
      expect: () => [
        isA<SignInLoadingState>(),// Check 1: Kya pehle loading aayi?  isA- stateIsA<SignInLoadingState>?
        isA<SignInSuccessState>(),// Check 2: Kya loading ke baad success aayi?
      ],


      verify: (_) {
        verify(() => mockAuthRepository.signIn('test@gmail.com', 'Password@123')).called(1);//Cubit ne sirf state nahi badli, balki piche se Repository ka function pakka 1 baar call bhi kiya.
      },
    );

    // --- Test 2: Failure Case ---
    blocTest<SignInCubit, SignInState>(
      'emits [Loading, Error] when signIn fails',

      build: () {
        // Arrange: Repository ko bolo error phenke
        when(() => mockAuthRepository.signIn(any(), any()))//Bhai kuch bhi email/pwd aaye
            .thenThrow('Invalid Credentials');// error hi throw karna h .Success ki jagah humne zabardasti error generate karwaya taaki Cubit ka catch block test ho sake.
        return signInCubit;
      },

      act: (cubit) => cubit.signIn(email: 'wrong@gmail.com', password: 'wrongpassword'),

      expect: () => [
        isA<SignInLoadingState>(),
        isA<SignInErrorState>(),// Check: Kya Success ki jagah Error state aayi?
      ],
    );
  });
}