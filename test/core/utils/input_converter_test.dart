import 'package:clean_architecture_tdd_example/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = new InputConverter();
  });
  group("stringToUnsignedString", () {
    test(
        'should return an integer when the string represents an unsiged integer',
        () async {
      // arrange
      final str = "123";
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Right(123));
    });

    test('should return failure when the string is not an integer', () async {
      // arrange
      final str = "123.2";
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is not an number', () async {
      // arrange
      final str = "abc";
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative number',
        () async {
      // arrange
      final str = "-100";
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
