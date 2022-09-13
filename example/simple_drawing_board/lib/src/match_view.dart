import 'package:drawing_board/drawing_board.dart';
import 'package:flutter/material.dart';

class MatchView extends StatefulWidget {
  const MatchView({Key? key}) : super(key: key);

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  bool isDrawing = false;

  var loading = true;
  late DrawingManager manager;

  @override
  void initState() {
    super.initState();

    manager = DrawingManager(
      Paint()
        ..strokeWidth = 10
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: DrawingBoard(manager: manager),
    );
  }
}
