import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd_example/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositories {}

void main() {
  MockNumberTriviaRepository _mockNumberTriviaRepository;
  GetConcreteNumberTrivia _usecase;

  setUp(() {
    _mockNumberTriviaRepository = new MockNumberTriviaRepository();
    _usecase = new GetConcreteNumberTrivia(_mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = new NumberTrivia(number: tNumber, text: "test");

  test("should get trivia for the number from repository", () async {
    // arrange
    when(_mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
      (_) async => Right(tNumberTrivia),
    );
    // act
    final result = await _usecase(Params(number: tNumber));
    // assert
    expect(result, Right(tNumberTrivia));
    verify(_mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(_mockNumberTriviaRepository);
  });
}
