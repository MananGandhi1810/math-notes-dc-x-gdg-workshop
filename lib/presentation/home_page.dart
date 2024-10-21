import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:math_notes_gdsc_workshop/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DrawingController _drawingController = DrawingController();
  GenerativeModel model = GenerativeModel(
    model: "gemini-1.5-pro-latest",
    apiKey: Constants.apiKey,
  );
  bool isErasing = false;

  @override
  void initState() {
    super.initState();
  }

  void generate() async {
    try {
      context.loaderOverlay.show();
      final image = await _drawingController.getImageData();
      if (image == null) {
        return;
      }
      final prompt = [
        Content.multi([
          TextPart(
            "What will be the result for this math problem? Only say the number nothing else. If there are multiple problems, answer all from top to bottom.",
          ),
          DataPart(
            "image/png",
            image.buffer.asUint8List(),
          ),
        ])
      ];
      final result = await model.generateContent(prompt);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Solution"),
            content: Text(result.text ?? "No Output"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DrawingBoard(
              controller: _drawingController,
              background: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
              ),
              panAxis: PanAxis.vertical,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _drawingController.undo(),
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                onPressed: () => _drawingController.redo(),
                icon: const Icon(Icons.redo),
              ),
              IconButton(
                onPressed: generate,
                icon: const Image(
                  image: AssetImage("assets/gemini-icon.png"),
                  height: 28,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isErasing = !isErasing;
                  });
                  _drawingController
                      .setPaintContent(isErasing ? Eraser() : SimpleLine());
                },
                icon: Icon(isErasing ? Icons.edit : Icons.backspace),
              ),
              IconButton(
                onPressed: () => _drawingController.clear(),
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
