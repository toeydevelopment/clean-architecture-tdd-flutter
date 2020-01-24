import 'package:clean_architecture_tdd_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:clean_architecture_tdd_example/injection_container.dart';
import 'package:clean_architecture_tdd_example/features/number_trivia/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          builder: (BuildContext context) => sl<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (BuildContext context, NumberTriviaState state) {
                      if (state is Empty) {
                        return MessageDisplay(
                          message: "Start Searching",
                        );
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(
                          trivia: NumberTrivia(
                            text: state.trivia.text,
                            number: state.trivia.number,
                          ),
                        );
                      } else if (state is Error) {
                        return MessageDisplay(
                          message: state.message,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TriviaControl()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlState createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: this.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (String value) {
            inputString = value;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
              child: Text("Search"),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                this._dispatchConcrete();
              },
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: RaisedButton(
              child: Text("Get Random Trivia"),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                this._dispatchRandom();
              },
            )),
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    this.controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaForConcreteNumber(this.inputString),
    );
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaRandomNumber(),
    );
  }
}
