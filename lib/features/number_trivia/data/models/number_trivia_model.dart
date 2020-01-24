import 'package:flutter/material.dart';

import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final int number;
  final String text;

  NumberTriviaModel({@required this.number, @required this.text})
      : super(
          number: number,
          text: text,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: (json['number'] as num).toInt(),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {"text": this.text, "number": this.number};
}
