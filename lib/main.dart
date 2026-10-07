import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ===============================
// StatelessWidget
// ===============================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const Calculator(),
    );
  }
}

// ===============================
// StatefulWidget
// ===============================
class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

// ===============================
// Calculator State
// ===============================
class _CalculatorState extends State<Calculator> {

  String display = "0";
  String result = "";

  String firstNumber = "";
  String secondNumber = "";
  String operation = "";

  // ===============================
  // Button Press
  // ===============================
  void buttonPressed(String value) {
    setState(() {

      // AC
      if (value == "AC") {
        this.display = "0";
        this.result = "";
        this.firstNumber = "";
        this.secondNumber = "";
        this.operation = "";
      }

      // Backspace
      else if (value == "⌫") {
        if (this.display.length > 1) {
          this.display =
              this.display.substring(0, this.display.length - 1);
        } else {
          this.display = "0";
        }
      }

      // Operators
      else if (value == "+" ||
          value == "-" ||
          value == "×" ||
          value == "÷") {

        if (this.firstNumber == "") {
          this.firstNumber = this.display;
          this.operation = value;

          // Screen پر operator بھی show ہوگا
          this.display = "${this.firstNumber} $value ";
        }
      }

      // Equal
      else if (value == "=") {
        try {
          if (this.firstNumber != "" &&
              this.secondNumber != "" &&
              this.operation != "") {

            double num1 = double.parse(this.firstNumber);
            double num2 = double.parse(this.secondNumber);

            double answer = 0;

            if (this.operation == "+") {
              answer = num1 + num2;
            }
            else if (this.operation == "-") {
              answer = num1 - num2;
            }
            else if (this.operation == "×") {
              answer = num1 * num2;
            }
            else if (this.operation == "÷") {

              if (num2 == 0) {
                throw Exception("Cannot divide by zero");
              }

              answer = num1 / num2;
            }

            this.result = formatNumber(answer);
          }
        } catch (e) {
          this.result = "Error";
        }
      }

      // Plus / Minus
      else if (value == "+/-") {
        if (this.secondNumber != "") {
          if (this.secondNumber.startsWith("-")) {
            this.secondNumber =
                this.secondNumber.substring(1);
          } else {
            this.secondNumber =
            "-${this.secondNumber}";
          }

          this.display =
          "${this.firstNumber} ${this.operation} ${this.secondNumber}";
        }
        else if (this.firstNumber == "") {
          if (this.display.startsWith("-")) {
            this.display =
                this.display.substring(1);
          } else {
            this.display = "-${this.display}";
          }
        }
      }

      // Percentage
      else if (value == "%") {
        try {
          double number;

          if (this.secondNumber != "") {
            number = double.parse(this.secondNumber);
            number = number / 100;
            this.secondNumber = formatNumber(number);

            this.display =
            "${this.firstNumber} ${this.operation} ${this.secondNumber}";
          } else {
            number = double.parse(this.display);
            number = number / 100;
            this.display = formatNumber(number);
          }
        } catch (e) {
          this.result = "Error";
        }
      }

      // Decimal
      else if (value == ".") {

        if (this.operation != "" &&
            this.secondNumber == "") {

          this.secondNumber = "0.";

          this.display =
          "${this.firstNumber} ${this.operation} ${this.secondNumber}";
        }

        else if (this.secondNumber != "") {

          if (!this.secondNumber.contains(".")) {
            this.secondNumber =
            "${this.secondNumber}.";
          }

          this.display =
          "${this.firstNumber} ${this.operation} ${this.secondNumber}";
        }

        else {

          if (!this.display.contains(".")) {
            this.display = "${this.display}.";
          }
        }
      }

      // Numbers
      else {

        // اگر operation select ہو چکا ہے
        if (this.operation != "") {

          this.secondNumber =
          "${this.secondNumber}$value";

          this.display =
          "${this.firstNumber} ${this.operation} ${this.secondNumber}";
        }

        // Normal number
        else {

          if (this.display == "0") {
            this.display = value;
          } else {
            this.display =
            "${this.display}$value";
          }
        }
      }
    });
  }

  // ===============================
  // Number Format
  // ===============================
  String formatNumber(double number) {

    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    return number.toString();
  }

  // ===============================
  // Calculator Button
  // ===============================
  Widget calculatorButton(
      String text, {
        bool isOperator = false,
        bool isEqual = false,
      }) {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),

        child: ElevatedButton(
          onPressed: () {
            buttonPressed(text);
          },

          style: ElevatedButton.styleFrom(

            // Button colors
            backgroundColor: isEqual
                ? Colors.lightBlue
                : isOperator
                ? Colors.blueGrey
                : const Color(0xFF303030),

            foregroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),

          child: Text(
            text,

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: isEqual
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Black Background
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator"),
      ),

      body: Column(
        children: [

          // ===============================
          // Display
          // ===============================
          Expanded(
            flex: 3,

            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              alignment: Alignment.bottomRight,

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.end,

                crossAxisAlignment:
                CrossAxisAlignment.end,

                children: [

                  // Entered numbers
                  SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,

                    child: Text(
                      this.display,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Result
                  Text(
                    this.result,

                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===============================
          // Row 1
          // ===============================
          Expanded(
            child: Row(
              children: [
                calculatorButton(
                  "AC",
                  isOperator: true,
                ),

                calculatorButton(
                  "⌫",
                  isOperator: true,
                ),

                calculatorButton(
                  "+/-",
                  isOperator: true,
                ),

                calculatorButton(
                  "÷",
                  isOperator: true,
                ),
              ],
            ),
          ),

          // ===============================
          // Row 2
          // ===============================
          Expanded(
            child: Row(
              children: [
                calculatorButton("7"),
                calculatorButton("8"),
                calculatorButton("9"),

                calculatorButton(
                  "×",
                  isOperator: true,
                ),
              ],
            ),
          ),

          // ===============================
          // Row 3
          // ===============================
          Expanded(
            child: Row(
              children: [
                calculatorButton("4"),
                calculatorButton("5"),
                calculatorButton("6"),

                calculatorButton(
                  "-",
                  isOperator: true,
                ),
              ],
            ),
          ),

          // ===============================
          // Row 4
          // ===============================
          Expanded(
            child: Row(
              children: [
                calculatorButton("1"),
                calculatorButton("2"),
                calculatorButton("3"),

                calculatorButton(
                  "+",
                  isOperator: true,
                ),
              ],
            ),
          ),

          // ===============================
          // Row 5
          // ===============================
          Expanded(
            child: Row(
              children: [
                calculatorButton("%"),
                calculatorButton("0"),
                calculatorButton("."),

                calculatorButton(
                  "=",
                  isEqual: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}