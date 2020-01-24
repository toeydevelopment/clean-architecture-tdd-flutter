import 'dart:convert';

import 'package:clean_architecture_tdd_example/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  ///
  /// Throwns [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// set the cached [NumberTriviaModel] which was gotten the last time
  ///
  /// Throwns [CacheException] if no cached data is present.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHE_NUMBER_TRIVIA = "CACHE_NUMBER_TRIVIA";

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = this.sharedPreferences.getString(CACHE_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else
      throw new CacheException();
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return this.sharedPreferences.setString(
          CACHE_NUMBER_TRIVIA,
          json.encode(
            triviaToCache.toJson(),
          ),
        );
  }
}
