import 'package:flutter/material.dart';

class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
    this.indexHovered,
  });

  final List<T> items;
  final Widget Function(T) builder;
  final int? indexHovered;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList();

  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_items.length, (index) {
            final item = _items[index];

            return DragTarget<T>(
              onAccept: (draggedItem) {
                setState(() {
                  // Place the dragged item in its new position
                  final oldIndex = _items.indexOf(draggedItem);
                  _items.removeAt(oldIndex);
                  _items.insert(index, draggedItem);
                });
              },
              onWillAccept: (draggedItem) {
                return draggedItem != item;
              },
              builder: (context, candidateData, rejectedData) {
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      hoveredIndex = index;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredIndex = null;
                    });
                  },
                  child: Draggable<T>(
                    data: item,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.7,
                        child: widget.builder(item),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.0,
                      child: widget.builder(item),
                    ),
                    onDragStarted: () {
                      setState(() {});
                    },
                    onDragCompleted: () {
                      setState(() {});
                    },
                    onDraggableCanceled: (_, __) {
                      setState(() {});
                    },
                    child: Transform.scale(
                      scale: hoveredIndex == index ? 1.2 : 1.0,
                      child: widget.builder(item),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
