import 'package:flutter/material.dart';

class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    required this.items,
    required this.builder,
    this.maxScale = 1.5,
    this.minScale = 0.9,
    this.hoverDuration = const Duration(milliseconds: 220),
  });

  final List<T> items;
  final Widget Function(T) builder;
  final double maxScale;
  final double minScale;
  final Duration hoverDuration;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T extends Object> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList(); // Local copy of the items list.

  int? hoveredIndex; // Tracks the index of the currently hovered item.

  bool isDragging = false; // Indicates whether an item is being dragged.

  int? dragIndex; // Tracks the potential drop position during a drag operation.

  // Calculates the scale factor for an item based on its distance from the hovered item.
  double _getScale(int index) {
    if (hoveredIndex == null) {
      return widget.minScale; // Default scale when no item is hovered.
    }

    final distance = (index - hoveredIndex!).abs(); // Distance from the hovered item.
    final scaleFactor = 1.0 / (distance + 1); // Scaling decreases with distance.
    return widget.minScale + (widget.maxScale - widget.minScale) * scaleFactor;
  }

  @override
  void initState() {
    super.initState();
    // Show the modal once the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverviewModal();
    });
  }

  // Function to display the modal with the task overview
  Future<void> _showOverviewModal() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blueGrey,
                  size: 40,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Draggable Icons!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Drag and drop icons around the screen and explore the possibilities. '
                      'Tap on the profile icon to learn more about me.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // The dock wraps its contents tightly.
        children: List.generate(_items.length, (index) {
          final item = _items[index]; // Current item in the list.

          return MouseRegion(
            onEnter: (_) {
              setState(() {
                hoveredIndex = index; // Update the hovered index on mouse enter.
              });
            },
            onExit: (_) {
              setState(() {
                hoveredIndex = null; // Reset hovered index on mouse exit.
              });
            },
            child: DragTarget<T>(
              // When an item is dragged over this target.
              onWillAccept: (draggedItem) {
                if (draggedItem != null && draggedItem != _items[index]) {
                  setState(() {
                    dragIndex = index; // Set the target drop index.
                  });
                  return true; // Accept the dragged item.
                }
                return false; // Reject if the dragged item is invalid.
              },
              // When a drag operation is completed and an item is dropped.
              onAccept: (draggedItem) {
                setState(() {
                  final oldIndex = _items.indexOf(draggedItem); // Original index of the dragged item.
                  _items.removeAt(oldIndex); // Remove the dragged item.
                  _items.insert(dragIndex!, draggedItem); // Insert it at the target index.
                  dragIndex = null; // Clear the drag index.
                });
              },
              // When a dragged item leaves this target without being dropped.
              onLeave: (draggedItem) {
                setState(() {
                  dragIndex = null; // Reset the drag index.
                });
              },
              // Build the item with scaling and animations.
              builder: (context, candidateData, rejectedData) {
                return TweenAnimationBuilder<double>(
                  duration: widget.hoverDuration, // Duration for the scaling animation.
                  curve: Curves.easeOut, // Smooth easing for the animation.
                  tween: Tween<double>(
                    begin: widget.minScale, // Starting scale.
                    end: _getScale(index), // Target scale based on hover.
                  ),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale, // Apply the calculated scale.
                      alignment: Alignment.center,
                      child: child, // Render the child widget.
                    );
                  },
                  child: Draggable<T>(
                    data: item, // Data associated with the dragged item.
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.7,
                        child: widget.builder(item),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.0, // Hide the original widget during drag.
                      child: widget.builder(item),
                    ),
                    onDragStarted: () {
                      setState(() {
                        isDragging = true; // Mark the drag as active.
                        dragIndex = index; // Initialize drag index.
                      });
                    },
                    onDragEnd: (_) {
                      setState(() {
                        isDragging = false; // Mark the drag as inactive.
                        dragIndex = null; // Clear the drag index.
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: widget.builder(item), // Build the widget for the item.
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
