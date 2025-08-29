
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({this.showMessage = true});

  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Visibility(
            visible: showMessage,
            child: Text(
              "Пожалуйста Подождите...",
              style: Theme.of(context).textTheme.bodyMedium
            ),
          )
        ],
      ),
    );
  }
  
  
}