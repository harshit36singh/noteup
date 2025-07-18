import 'package:flutter/material.dart';
import 'package:noteup/event_page.dart';
import 'package:noteup/my_notes_page.dart';
import 'package:noteup/routine_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteup/setting_page.dart';

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  int selectedIndex = 0;
  User? currentUser = FirebaseAuth.instance.currentUser;

  final List<NavItem> navItems = [
    NavItem('Todo', Color(0xFF81E6D9)), // Teal 200
    NavItem('Routine', Color(0xFFFBB6CE)), // Pink 200
    NavItem('Event', Color(0xFF90CDF4)), // Blue 200
    NavItem('Notes', Color(0xFFFFF59D)),
    NavItem("Settings",Color.fromARGB(255, 230, 129, 218) ) // Yellow 200
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F1E8),
        body: Row(
          children: [
            // Left Navigation Bar
            Container(
              width: 80,
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  ...navItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    NavItem item = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 100,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  color:
                                      selectedIndex == index
                                          ? Colors.white
                                          : Colors.black54,
                                  fontSize: selectedIndex == index ? 18 : 14,
                                  fontWeight:
                                      selectedIndex == index
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            // Main Content Area
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return TodoPage();
      case 1:
        return RoutinePage();
      case 2:
        return EventPage();
      case 3:
        return MyNotesPage();
      case 4:
        return SettingsPage();
      default:
        return TodoPage();
    }
  }
}

class NavItem {
  final String name;
  final Color color;

  NavItem(this.name, this.color);
}

class Task {
  String title;
  bool isCompleted;
  Task({required this.title, this.isCompleted = false});
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  DateTime selectedDate = DateTime.now().toLocal();
  Map<DateTime, List<Task>> tasksByDate = {};

  List<Task> get todayTasks => tasksByDate[selectedDate] ?? [];

  void _addTask(String title) {
    final newTask = Task(title: title, isCompleted: false);
    setState(() {
      tasksByDate[selectedDate] = [...todayTasks, newTask];
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white70,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showAddTaskDialog() {
    String newTaskTitle = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          false, // This allows it to resize when keyboard appears
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // prevents keyboard overlap
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                onChanged: (value) => newTaskTitle = value,
                decoration: const InputDecoration(
                  hintText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (newTaskTitle.trim().isNotEmpty) {
                        _addTask(newTaskTitle);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.grey[200],
        body: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Task List
              if (todayTasks.isEmpty)
                const Text(
                  "No tasks for this day",
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...todayTasks.map(
                  (task) => ListTile(
                    title: Text(task.title),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (val) {
                        setState(() {
                          task.isCompleted = val ?? false;
                        });
                      },
                    ),
                  ),
                ),

              const Spacer(),

              // Reschedule + Add
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: _showAddTaskDialog,
                      backgroundColor: const Color(0xFF81E6D9),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
