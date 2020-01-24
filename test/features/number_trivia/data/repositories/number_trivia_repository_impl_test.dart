import 'package:clean_architecture_tdd_example/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_example/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd_example/core/network/network_info.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDatasource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl _repository;
  MockRemoteDatasource _mockRemoteDatasource;
  MockLocalDatasource _mockLocalDatasource;
  MockNetworkInfo _mockNetworkInfo;

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(_mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(_mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  setUp(() {
    _mockRemoteDatasource = new MockRemoteDatasource();
    _mockLocalDatasource = new MockLocalDatasource();
    _mockNetworkInfo = new MockNetworkInfo();
    _repository = new NumberTriviaRepositoryImpl(
      remoteDatasource: _mockRemoteDatasource,
      localDatasource: _mockLocalDatasource,
      networkInfo: _mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(_mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      _repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(_mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await _repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(_mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when call to remote data source is successful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await _repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(_mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verify(_mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'should return failure when call to remote data source is unsuccessful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await _repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(_mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(_mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline(() {
      test(
          'should return last locally cahced data when the cached data is present',
          () async {
        // arrange
        when(_mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await _repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(_mockRemoteDatasource);
        verify(_mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure when the cached data is no cache data present',
          () async {
        // arrange
        when(_mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await _repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(_mockRemoteDatasource);
        verify(_mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async {
      // arrange
      when(_mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      _repository.getRandomNumberTrivia();
      // assert
      verify(_mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await _repository.getRandomNumberTrivia();
          // assert
          verify(_mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when call to remote data source is successful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await _repository.getRandomNumberTrivia();
          // assert
          verify(_mockRemoteDatasource.getRandomNumberTrivia());
          verify(_mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );
      test(
        'should return failure when call to remote data source is unsuccessful',
        () async {
          // arrange
          when(_mockRemoteDatasource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await _repository.getRandomNumberTrivia();
          // assert
          verify(_mockRemoteDatasource.getRandomNumberTrivia());
          verifyZeroInteractions(_mockLocalDatasource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline(() {
      test(
          'should return last locally cahced data when the cached data is present',
          () async {
        // arrange
        when(_mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await _repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(_mockRemoteDatasource);
        verify(_mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure when the cached data is no cache data present',
          () async {
        // arrange
        when(_mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await _repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(_mockRemoteDatasource);
        verify(_mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

}
