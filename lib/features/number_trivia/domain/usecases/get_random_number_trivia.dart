import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:clean_architecture_tdd_example/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepositories _repositories;

  GetRandomNumberTrivia(this._repositories);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await this._repositories.getRandomNumberTrivia();
  }
}

