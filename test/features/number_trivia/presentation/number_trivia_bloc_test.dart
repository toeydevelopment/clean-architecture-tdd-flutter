import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:clean_architecture_tdd_example/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_example/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = new MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = new MockGetRandomNumberTrivia();
    mockInputConverter = new MockInputConverter();
    bloc = new NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      inputConverter: mockInputConverter,
      random: mockGetRandomNumberTrivia,
    );
  });

  test('should initialState must be empty', () async {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = new NumberTrivia(
      number: 1,
      text: "test trivia",
    );

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
          Right(tNumberParsed),
        );

    test(
        'should call the InoutConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get from the concrete usecase', () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(
        mockGetConcreteNumberTrivia(
          Params(number: tNumberParsed),
        ),
      );
    });

    test('should emit [Loading,Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(
          trivia: tNumberTrivia,
        ),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading,Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Left(ServerFailure()),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading,Error] when a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Left(CacheFailure()),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group("GetTriviaForRandomNumber", () {
    final tNumberTrivia = new NumberTrivia(
      number: 1,
      text: "test trivia",
    );

    test('should emit [Loading,Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(
          trivia: tNumberTrivia,
        ),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaRandomNumber());
    });

    test('should emit [Loading,Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer(
        (_) async => Left(ServerFailure()),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaRandomNumber());
    });

    test(
        'should emit [Loading,Error] when a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer(
        (_) async => Left(CacheFailure()),
      );
      // assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      // act
      bloc.dispatch(GetTriviaRandomNumber());
    });
  });
}
