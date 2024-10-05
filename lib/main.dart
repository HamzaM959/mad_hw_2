import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _displayText = '';
  String _expression = '';

  //Function that handles number and operator button presses
  void _onButtonPressed(String value) {
    setState(() {
      _expression += value;
      _displayText = _expression;
    });
  }

  //Function that clears the display and expression
  void _onClearPressed() {
    setState(() {
      _expression = '';
      _displayText = '';
    });
  }

  //Function that handles the = button
  void _onEqualsPressed() {
    setState(() {
      int result = calculate(_expression);
      _displayText = result.toString();
      _expression =
          result.toString(); //Resets the expression to the result
    });
  }

  //Function that calculates the result
  int calculate(String given) {
    List<int> stack = []; //Using a list as a stack
    int currentNumber = 0;
    String lastOperator = '+'; //Initially assumes we are adding numbers

    for (int i = 0; i < given.length; i++) {
      String char = given[i];

      //Checks if the character is a digit
      if (char.isNotEmpty && int.tryParse(char) != null) {
        currentNumber = currentNumber * 10 +
            int.parse(char); //Accumulates multi-digit numbers
      }

      //If we encounter an operator or reach the end of the string
      if ("+-*/".contains(char) || i == given.length - 1) {
        switch (lastOperator) {
          case '+':
            stack.add(currentNumber);
            break;
          case '-':
            stack.add(-currentNumber);
            break;
          case '*':
            stack[stack.length - 1] *=
                currentNumber; //Multiplies with the top value of the stack
            break;
          case '/':
            stack[stack.length - 1] ~/=
                currentNumber; //Integer division with the top value
            break;
        }

        //Updates the lastOperator and reset currentNumber
        lastOperator = char;
        currentNumber = 0;
      }
    }

    //Sums up all valuues in the stack to get the result
    int result = 0;
    for (int val in stack) {
      result += val;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _displayText,
              style: TextStyle(fontSize: 48),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildButtonRow('1', '2', '3', '/'),
                _buildButtonRow('4', '5', '6', '*'),
                _buildButtonRow('7', '8', '9', '-'),
                _buildButtonRow('0', 'C', '=', '+'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Function that builds each row of buttons
  Widget _buildButtonRow(
      String button1, String button2, String button3, String button4) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildButton(button1),
          _buildButton(button2),
          _buildButton(button3),
          _buildButton(button4),
        ],
      ),
    );
  }

  //Function that builds each button
  Widget _buildButton(String buttonText) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (buttonText == 'C') {
            _onClearPressed(); //Clears the display when C is pressed
          } else if (buttonText == '=') {
            _onEqualsPressed(); //Calculates the result when = is pressed
          } else {
            _onButtonPressed(buttonText); //Otherwise updates expression
          }
        },
        child: Container(
          margin: EdgeInsets.all(1),
          color: Colors.grey[200],
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
      ),
    );
  }
}
