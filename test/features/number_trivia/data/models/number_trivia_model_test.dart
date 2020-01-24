import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_tdd_example/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTriviaModel>());
  });

  group("fromJson", () {
    test('should return a valid model when the json number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
        'should return a valid model when the json number is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_double.json"));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test("should return a Json map containing the proper data", () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
