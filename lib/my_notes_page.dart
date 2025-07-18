import 'package:flutter/material.dart';

class MyNotesPage extends StatefulWidget {
  const MyNotesPage({super.key});

  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  final List<Map<String, dynamic>> _notes = [];
  final TextEditingController _noteController = TextEditingController();

  final List<Color> _noteColors = [
    const Color.fromARGB(255, 216, 205, 171),
    const Color.fromARGB(255, 216, 205, 171),
    const Color.fromARGB(255, 216, 205, 171),
    const Color.fromARGB(255, 216, 205, 171),
    const Color.fromARGB(255, 216, 205, 171),
    const Color.fromARGB(255, 216, 205, 171),
  ];

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.add({
          'text': text,
          'created': DateTime.now(),
          'color': _noteColors[_notes.length % _noteColors.length],
        });
        _noteController.clear();
      });
    }
  }

  void _editNote(int index) {
    _noteController.text = _notes[index]['text'];
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Note'),
            content: TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Enter your note...'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _notes[index]['text'] = _noteController.text;
                    _noteController.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
         appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(228, 230, 103, 0.502),
            ),
          ),
          title: const Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(252, 252, 251, 1),
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          elevation: 4,
        ))),
        body: Column(
          children: [
            // Input Box
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 244, 244, 244),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: "Write something...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addNote,
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color.fromARGB(255, 133, 142, 128),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
      
            // Notes List
            Expanded(
              child:
                  _notes.isEmpty
                      ? const Center(
                        child: Text(
                          "No notes yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return Card(
                            color: note['color'],
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                note['text'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "Added: ${note['created'].toString().split('.')[0]}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _editNote(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteNote(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
