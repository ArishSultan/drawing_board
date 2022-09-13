part of drawing_board;

enum DrawingEventType {
  stop,
  start,
  clear,
  update,
}

class DrawingEvent {
  const DrawingEvent({
    required this.id,
    required this.type,
    required this.offset,
  });

  final int id;
  final Offset offset;
  final DrawingEventType type;
}
