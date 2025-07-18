import 'package:flutter/material.dart';

class Routine {
  String title;
  TimeOfDay time;

  Routine({required this.title, required this.time});
}

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  String selectedDay = 'Monday';
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Map<String, List<Routine>> routines = {};

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      routines[day] = [];
    }
  }

  void _addRoutine() {
    String routineTitle = '';
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add Routine'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Routine Title'),
                  onChanged: (value) => routineTitle = value,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  icon: const Icon(Icons.access_time),
                  label: const Text("Pick Time"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (routineTitle.isNotEmpty && selectedTime != null) {
                    setState(() {
                      routines[selectedDay]!.add(
                        Routine(title: routineTitle, time: selectedTime!),
                      );
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _editRoutine(int index) {
    String updatedTitle = routines[selectedDay]![index].title;
    TimeOfDay? updatedTime = routines[selectedDay]![index].time;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Routine'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: updatedTitle,
                  decoration: const InputDecoration(labelText: 'Routine Title'),
                  onChanged: (value) => updatedTitle = value,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: updatedTime!,
                    );
                    if (picked != null) updatedTime = picked;
                  },
                  icon: const Icon(Icons.access_time),
                  label: const Text("Edit Time"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    routines[selectedDay]![index] = Routine(
                      title: updatedTitle,
                      time: updatedTime!,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _deleteRoutine(int index) {
    setState(() {
      routines[selectedDay]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Scaffold(
          
          appBar: AppBar(
            
            title: const Text('Routine'),
            backgroundColor: Color(0xFFFBB6CE),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Day Selector
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isSelected = day == selectedDay;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
        
                // Routine List
                Expanded(
                  child:
                      routines[selectedDay]!.isEmpty
                          ? const Center(child: Text('No routines for this day.'))
                          : ListView.builder(
                            itemCount: routines[selectedDay]!.length,
                            itemBuilder: (_, index) {
                              final routine = routines[selectedDay]![index];
                              return Card(
                                child: ListTile(
                                  title: Text(routine.title),
                                  subtitle: Text(routine.time.format(context)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _editRoutine(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _deleteRoutine(index),
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
          floatingActionButton: FloatingActionButton(
            onPressed: _addRoutine,
            backgroundColor: Color(0xFFFBB6CE),
            child: const Icon(Icons.add,color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
    );
  }
}
