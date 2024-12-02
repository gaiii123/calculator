//IM_2021_097
//Gayan Nagasinghe

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller
  List<String> symbols = [
    'C',
    'Del',
    '%',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    '√',
    '0',
    '.',
    '=',
  ];
  String input = '';
  String output = '';
  String previousInput = '';
  bool isResultDisplayed = false;

  // Modified formatOutput function
  String formatOutput(String output) {
    try {
      // Parse the output as a double
      double number = double.parse(output);

      // Check if the number is an integer
      if (number == number.toInt()) {
        return number.toInt().toString(); // Display as integer
      } else {
        // For decimal numbers, limit to 8 decimal places
        return number
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      // If parsing fails, return the original output
      return output;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final inputTextSize = screenWidth * 0.1;
    final previousInputTextSize = screenWidth * 0.06;
    final buttonTextSize = screenWidth * 0.08;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: showHistoryDialog, // Show history dialog
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.bottomRight,
              child: Text(
                previousInput.isEmpty ? '' : previousInput,
                style: TextStyle(
                  fontSize: previousInputTextSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                controller: _scrollController, // Attach the ScrollController
                scrollDirection: Axis.horizontal, // Allow horizontal scrolling
                child: Text(
                  input.isEmpty ? '0' : input, // Input text
                  style: TextStyle(
                    fontSize: inputTextSize,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Prevent overflow to second line
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: symbols.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onButtonPressed(symbols[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 17, 17, 17),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        symbols[index],
                        style: TextStyle(
                          color: myTextColor(symbols[index]),
                          fontWeight: FontWeight.w500,
                          fontSize: buttonTextSize,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onButtonPressed(String symbol) {
    setState(() {
      if (symbol == 'C') {
        input = '';
        output = '';
        previousInput = '';
        isResultDisplayed = false;
      } else if (symbol == 'Del') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
      } else if (['+', '-', '*', '/'].contains(symbol)) {
        if (isResultDisplayed) {
          // Use the previous result as the starting point for new calculations
          isResultDisplayed = false;
          input = output;
        }
        if (input.isEmpty) {
          input = '0$symbol';
        } else if (['+', '-', '*', '/'].contains(input[input.length - 1])) {
          input = input.substring(0, input.length - 1) + symbol;
        } else {
          input += symbol;
        }
      } else if (symbol == '.') {
        String lastNumber = getCurrentNumber(input);
        if (lastNumber.isEmpty) {
          input += '0.';
        } else if (!lastNumber.contains('.')) {
          input += '.';
        }
      } else if (RegExp(r'\d').hasMatch(symbol)) {
        if (isResultDisplayed) {
          // Start a new calculation with the entered number
          input = symbol;
          isResultDisplayed = false;
        } else {
          input += symbol;
        }
      } else if (symbol == '√') {
        if (input.isNotEmpty &&
            (input[input.length - 1] == '√' ||
                ['+', '-', '*', '/'].contains(input[input.length - 1]))) {
          return; // Ignore invalid placement
        }
        input += '√';
      } else if (symbol == '%') {
        if (input.isNotEmpty &&
            !['+', '-', '*', '/'].contains(input[input.length - 1])) {
          try {
            String lastNumber = getCurrentNumber(input);
            double lastValue = double.parse(lastNumber);

            // Calculate percentage (convert to decimal)
            double percentage = lastValue / 100;

            // Append the % symbol and calculate the result
            input =
                '${input.substring(0, input.length - lastNumber.length)}${formatOutput(lastValue.toString())}%';
            output = formatOutput(
                percentage.toString()); // Show the percentage result
          } catch (e) {
            input = 'Error';
          }
        }
      } else if (symbol == '%') {
        if (input.isNotEmpty &&
            !['+', '-', '*', '/'].contains(input[input.length - 1])) {
          try {
            // Get the last number entered (before %)
            String lastNumber = getCurrentNumber(input);
            double lastValue = double.parse(lastNumber);

            // Calculate percentage (convert to decimal)
            double percentage = lastValue / 100;

            // Append the % symbol and calculate the result
            input =
                '${input.substring(0, input.length - lastNumber.length)}${formatOutput(lastValue.toString())}%';
            output = formatOutput(
                percentage.toString()); // Show the percentage result
          } catch (e) {
            input = 'Error';
          }
        }
      } else if (symbol == '=') {
        try {
          // Check for division by zero
          if (input.contains('/0')) {
            if (input == '0/0') {
              input = "Indeterminate"; // Handle 0/0
            } else if (input.contains('/0')) {
              input = "undefined"; // Handle other numbers divided by 0
            } else {
              output = "Error"; // Catch any other unexpected division issues
            }
          } else {
            // Replace "√" with "sqrt(" for the math expression
            String expressionToEvaluate = input.replaceAllMapped(
              RegExp(r'√([0-9.]+)'),
              (match) => 'sqrt(${match.group(1)})',
            );
            // Handle percentage operator: if there's a `%`, convert it to proper expression
            expressionToEvaluate = expressionToEvaluate.replaceAll('%', '/100');

            // Use the expression parser to evaluate the result
            Expression exp = Parser().parse(expressionToEvaluate);
            double result = exp.evaluate(EvaluationType.REAL, ContextModel());
            previousInput = input;
            output = formatOutput(result.toString());
            input = output; // Allow continuous calculations with the result
            history.add('$previousInput = $output');
          }
        } catch (e) {
          input = 'Error';
        }
        isResultDisplayed = true;
      }

      // Prevent invalid leading zeros globally
      if (input.startsWith('0') &&
          input.length > 1 &&
          !input.startsWith('0.')) {
        input = input.replaceFirst(RegExp(r'^0+'), '0');
      }

      // Automatically scroll to the end of the input after changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

// Helper function to get the current number being entered
  String getCurrentNumber(String input) {
    final matches = RegExp(r'[0-9]*\.?[0-9]+$').allMatches(input);
    return matches.isEmpty ? '' : matches.first.group(0) ?? '';
  }

  Color myTextColor(String x) {
    if (['%', '/', '*', '+', '-', '=', '√'].contains(x)) {
      return const Color.fromARGB(255, 44, 109, 153);
    } else if (['C'].contains(x)) {
      return const Color.fromARGB(255, 59, 158, 142);
    } else if (['Del'].contains(x)) {
      return const Color.fromARGB(255, 202, 77, 77);
    }
    return const Color.fromARGB(255, 255, 255, 255);
  }

  void showHistoryDialog() {
    bool isEditMode = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('History'),
                  Row(
                    children: [
                      if (history.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            isEditMode ? Icons.done : Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                        ),
                      if (history.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Clear All History'),
                                  content: const Text(
                                      'Are you sure you want to clear all history?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Clear All'),
                                      onPressed: () {
                                        setState(() {
                                          history.clear();
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                height: 300, // Fixed height for the history box
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(history[index]),
                      trailing: isEditMode
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  history.removeAt(index);
                                });
                              },
                            )
                          : null,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final List<String> history = [];
}
