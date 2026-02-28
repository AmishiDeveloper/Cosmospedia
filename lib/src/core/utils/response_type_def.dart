import 'package:fpdart/fpdart.dart';

typedef FutureResult<T> = Future<Either<CustomError, T>>;
typedef VoidResult<Void> = Future<Either<CustomError, Void>>;

class CustomError {
  final String message;
  final int? code;
  CustomError(this.message, this.code);
}