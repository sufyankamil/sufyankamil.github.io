import 'package:flutter/material.dart';

import 'icons.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final List<String> dockItems = ["📁", "📧", "🌐", "📸", "🎵"]; // Strings

  final List<IconData> dockItems = [
    Icons.folder,
    Icons.email,
    Icons.public,
    Icons.camera_alt,
    Icons.music_note,
  ];

  double hoveredScale = 1.2;

  int? hoveredIndex;

  String? draggedItem;

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const IconsWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.7),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(dockItems.length, (index) {
                      return DragTarget<IconData>(
                        onAccept: (data) {
                          setState(() {
                            // Remove the dragged item from its old position and insert it into the new position.
                            final oldIndex = dockItems.indexOf(data);
                            final newIndex = index;
                            dockItems.removeAt(oldIndex);
                            dockItems.insert(newIndex, data);
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${dockItems[index]} clicked!'),
                              ));
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() => hoveredIndex = index);
                              },
                              onExit: (_) {
                                setState(() => hoveredIndex = null);
                              },
                              child: Draggable<IconData>(
                                data: dockItems[index],
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    height: hoveredIndex == index ? 80 : 60,
                                    width: hoveredIndex == index ? 80 : 60,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      dockItems[index],
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                childWhenDragging: const SizedBox(),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  height: hoveredIndex == index ? 80 : 60,
                                  width: hoveredIndex == index ? 80 : 60,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    dockItems[index],
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
