import 'dart:convert';
import 'package:clean_architecture_tdd_example/core/error/exceptions.dart';
import "package:matcher/matcher.dart";

import 'package:clean_architecture_tdd_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDatasourceImpl datasourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = new MockSharedPreferences();
    datasourceImpl = new NumberTriviaLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture("trivia_cached.json"),
      ),
    );

    test(
        'should return NumberTrivia from SharedPrefernces when there is one in tht cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(
        fixture("trivia_cached.json"),
      );
      // act
      final result = await datasourceImpl.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(
        null,
      );
      // act
      final call = await datasourceImpl.getLastNumberTrivia;
      // assert
      verifyNever(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("cachedNumberTrivia", () {
    final tNumberTriviaModel = new NumberTriviaModel(
      number: 1,
      text: "Text trivia",
    );
    test('should call SharedPrefernces to cache the data', () async {
      // arrange
      // act
      datasourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHE_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
