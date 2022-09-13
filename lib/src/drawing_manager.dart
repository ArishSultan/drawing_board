part of drawing_board;

///
class DrawingManager<T extends DrawingEvent> {
  ///
  DrawingManager(this.paint);

  ///
  Paint paint;

  ///
  bool get drawPointer => true;

  ///
  void addDrawingEvent(T event) {
    switch (event.type) {
      case DrawingEventType.stop:
        _stopInteractionAndRecord();
        break;
      case DrawingEventType.start:
        _path.moveTo(event.offset.dx, event.offset.dy);
        break;
      case DrawingEventType.clear:
        _picture = null;
        _path.reset();
        break;
      case DrawingEventType.update:
        _path.lineTo(event.offset.dx, event.offset.dy);
        break;
    }

    _board?.markNeedsPaint();
  }

  void _bind(RenderDrawingBoard board, {bool clear = false}) {
    _board = board;

    if (clear) {
      _path.reset();
      _picture = null;
    }

    _board!.markNeedsPaint();
  }

  void _stopInteractionAndRecord() {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    if (_picture != null) {
      canvas.drawPicture(_picture!);
    }

    canvas.drawPath(_path, paint);

    _picture = recorder.endRecording();
    _path.reset();
  }

  final _path = Path();

  Picture? _picture;
  RenderDrawingBoard? _board;
}
