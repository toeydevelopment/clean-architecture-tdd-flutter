import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:clean_architecture_tdd_example/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepositories _repositories;
  GetConcreteNumberTrivia(this._repositories);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await this._repositories.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}
