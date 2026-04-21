import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/data/model/user_model/user_model.dart';
import 'package:cosmospedia/src/data/repository/auth_repo/auth_repository.dart';
import 'package:cosmospedia/src/logic/cubits/auth/sign_up_cubit/sign_up_cubit.dart';

// 1. Nakli Repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpCubit signUpCubit;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() { //test file mein sirf ek baar chalta hai (sabse pehle).
    // Mocktail ko batana padta hai ki UserModel ek valid parameter hai verify ke liye
    registerFallbackValue(UserModel(uid: '', email: '', name: ''));//registerFallbackValue: Ye batata h ki Jab niche verify mein any() use karenge, toh mocktail ko confusion hota hai ki any() kis type ka object hai. Humne use pehle hi bata diya agar any() aaye toh use UserModel jaisa treat karna.
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    // GetIt setup: Purani repo hatao aur Mock repo dalo
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerSingleton<AuthRepository>(mockAuthRepository);

    signUpCubit = SignUpCubit();
  });

  tearDown(() {
    signUpCubit.close();
  });

  group('SignUpCubit Tests', () {
    final tName = 'Amishi';
    final tEmail = 'test@gmail.com';
    final tPassword = 'Password@123';

    // --- Test 1: Success Case ---
    blocTest<SignUpCubit, SignUpState>( // test name
      'emits [Loading, Success] when signUp is successful',
      build: () {
        // Arrange: Repository ko bolo ki success return kare
        // any() ka use isliye taaki humein exact object match na karna pade
        when(() => mockAuthRepository.signUp(any(), any())) //Cubit ke andar ek naya UserModel banta hai. Hum test mein exact wahi object predict nahi kar sakte isliye humne any() likha, jiska matlab hai  koi bhi user model aur koi bhi password aaye, success return karo
            .thenAnswer((_) async => {}); //koi bhi data aaye Success bol dena.
        return signUpCubit;
      },
      act: (cubit) => cubit.signUpUser( //Cubit ka function call kiya jisse test karna tha. Isse Cubit ke andar ka logic start ho jayega.
        name: tName,
        email: tEmail,
        password: tPassword,
      ),
      expect: () => [
        isA<SignUpLoadingState>(),
        isA<SignUpSuccessState>(),
      ],
      verify: (_) {
        // Check karo ki repo ka signUp call hua ya nahi
        verify(() => mockAuthRepository.signUp(any(), tPassword)).called(1);//check kiya ki kya Cubit ne sach mein Repository ka signUp method call kiya? Agar called(1) nahi hua, toh test fail ho jayega.
      },
    );

    // --- Test 2: Error Case ---
    blocTest<SignUpCubit, SignUpState>(
      'emits [Loading, Error] when signUp fails',
      build: () {
        // Arrange: Repository error throw karegi
        when(() => mockAuthRepository.signUp(any(), any()))
            .thenThrow('Email already in use');
        return signUpCubit;
      },
      act: (cubit) => cubit.signUpUser(
        name: tName,
        email: tEmail,
        password: tPassword,
      ),
      expect: () => [
        isA<SignUpLoadingState>(),
        isA<SignUpErrorState>(),
      ],
    );
  });
}