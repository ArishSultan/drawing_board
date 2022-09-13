part of drawing_board;

enum DrawingEventType {
  stop,
  start,
  clear,
  update,
}

class DrawingEvent {
  const DrawingEvent({
    required this.type,
    required this.offset,
    required this.timestamp,
  });

  final Offset offset;
  final int timestamp;
  final DrawingEventType type;
}
