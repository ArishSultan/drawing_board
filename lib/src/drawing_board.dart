part of drawing_board;

class DrawingBoard extends LeafRenderObjectWidget {
  const DrawingBoard({super.key, required this.manager});

  final DrawingManager manager;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDrawingBoard._(manager);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderDrawingBoard renderObject,
  ) =>
      renderObject._setManager(manager);
}

class RenderDrawingBoard extends RenderBox implements MouseTrackerAnnotation {
  RenderDrawingBoard._(this._manager) {
    _setManager(_manager);
  }

  DrawingManager _manager;

  void _setManager(DrawingManager manager) {
    _manager = manager;
    _manager._bind(this);
  }

  @override
  bool get sizedByParent => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_manager._picture != null) {
      context.canvas.drawPicture(_manager._picture!);
    }

    context.canvas.drawPath(_manager._path, _manager.paint);

    if (_manager.drawPointer && _pointer != null) {
      context.canvas.drawCircle(
        _pointer!,
        _manager.paint.strokeWidth / 2,
        Paint()
          ..color = _manager.paint.color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position)) {
      _pointer = position;
      markNeedsPaint();

      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  int? _pointerId;
  Offset? _pointer;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent && _pointerId == null) {
      _pointerId = event.pointer;
      _manager.addDrawingEvent(event.toEvent(DrawingEventType.start));
    } else if (event is PointerUpEvent && _pointerId == event.pointer) {
      _pointerId = null;
      _manager.addDrawingEvent(event.toEvent(DrawingEventType.stop));
    } else if (event is PointerMoveEvent && _pointerId == event.pointer) {
      _manager.addDrawingEvent(event.toEvent(DrawingEventType.update));
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.none;

  @override
  PointerEnterEventListener? onEnter;

  @override
  PointerExitEventListener? get onExit => (event) {
    if (_pointer != null) {
      _pointer = null;
      markNeedsPaint();
    }
  };

  @override
  bool validForMouseTracker = true;
}

extension _XPointerEvent on PointerEvent {
  DrawingEvent toEvent(DrawingEventType type) {
    return DrawingEvent(
      type: type,
      offset: position,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
