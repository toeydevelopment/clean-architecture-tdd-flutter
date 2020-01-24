import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:clean_architecture_tdd_example/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_example/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid Input";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          this.inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((Failure failure) async* {
        yield Error(
          message: INVALID_INPUT_FAILURE_MESSAGE,
        );
      }, (int integer) async* {
        yield Loading();
        final failureOrTrivia =
            await this.getConcreteNumberTrivia(Params(number: integer));
        yield failureOrTrivia.fold(
            (Failure failure) => Error(
                  message: this._meesageFailureToMessage(failure),
                ),
            (NumberTrivia trivia) => Loaded(
                  trivia: trivia,
                ));
      });
    } else if (event is GetTriviaRandomNumber) {
      yield Loading();
      final failureOrTrivia = await this.getRandomNumberTrivia(NoParams());
      yield failureOrTrivia.fold(
        (Failure failure) => Error(
          message: this._meesageFailureToMessage(failure),
        ),
        (NumberTrivia trivia) => Loaded(
          trivia: trivia,
        ),
      );
    }
  }

  String _meesageFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
