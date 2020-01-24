import 'package:dartz/dartz.dart';

import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepositories {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}