import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<String>> _events = {};

  List<String> get _selectedEvents => _events[_normalize(_selectedDay)] ?? [];

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _addEventDialog() {
    String newEvent = '';
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Event'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'e.g. Mom\'s Birthday',
              ),
              onChanged: (val) => newEvent = val,
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  if (newEvent.trim().isEmpty) return;
                  setState(() {
                    final day = _normalize(_selectedDay);
                    if (_events[day] != null) {
                      _events[day]!.add(newEvent);
                    } else {
                      _events[day] = [newEvent];
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
            child: AppBar(
              title: const Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 125, 180, 222),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
          ),
        ),

        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0,0), // add margin so rounded border is visible
          decoration: BoxDecoration(
            color:
                Colors
                    .white, // required to show the background inside the rounded border
           borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias, // clips children to the rounded border
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  return _events[_normalize(day)] ?? [];
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 169, 104),
                    shape: BoxShape.rectangle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 166, 135, 218),
                    shape: BoxShape.rectangle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 162, 143, 213),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events on ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addEventDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    _selectedEvents.isEmpty
                        ? const Center(
                          child: Text(
                            'No events for this day.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _selectedEvents.length,
                          itemBuilder:
                              (_, index) => ListTile(
                                leading: const Icon(Icons.event_note),
                                title: Text(_selectedEvents[index]),
                              ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widgets
class TaskItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final Color? color;

  const TaskItem({
    Key? key,
    required this.title,
    required this.isCompleted,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? (color ?? Colors.purple) : Colors.transparent,
            border: Border.all(
              color: isCompleted ? (color ?? Colors.purple) : Colors.grey[400]!,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              isCompleted
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3748),
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
