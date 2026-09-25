import 'package:b2b_seller/core/errors/exceptions.dart';
import 'package:b2b_seller/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

//all answers of api go through  this class's method
mixin RemoteSafeRunner {
  Future<Either<Failure, T>> runSafely<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        GeneralFailure.fromDioException(e),
      );
    } on HttpException catch (e) {
      return Left(
        HttpFailure.fromException(e),
      );
      // return Left(HttpFailure.fromException(e));
    } on ClientException catch (e) {
      return Left(
        GeneralFailure(message: e.message),
      );
      //return Left(ClientFailure.fromException(e));
    } on GeneralException catch (e) {
      return Left(
        //GeneralFailure(message: e.message),
        GeneralFailure(message: e.message),
      );
      // return Left(GeneralFailure.fromException(e));
    } catch (e) {
      return Left(
        //GeneralFailure(message: e.toString()),
        GeneralFailure(message: e.toString()),
      );
    }
  }
}
