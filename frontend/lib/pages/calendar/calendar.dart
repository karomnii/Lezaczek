import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/api/event_api.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/pages/calendar/event_details.dart';
import 'package:frontend/pages/calendar/event_form.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  late Future<List<Event>> futureEvents;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    setState(() {
      try {
        futureEvents = EventService.getEventsByDate(
            DateFormat('yyyy-MM-dd').format(selectedDate));
        if (errorMessage != null) {
          errorMessage = null;
        }
      } catch (e) {
        errorMessage = e is Error ? e.text : 'Unexpected error occurred';
      }
    });
  }

  void _addEvent(Event event, BuildContext context) {
    EventService.createEvent(event).catchError((e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Zamknij',
                    )),
              ],
            )
          ],
          title: const Text('Error occurred'),
          content: Text(e is Error ? e.text : 'Unexpected error occurred'),
          contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
      return null;
    }).then((res) {
      Event? createdEvent = res;
      if (createdEvent == null) {
        return;
      }
      setState(() {
        futureEvents = futureEvents.then((events) {
          events.add(createdEvent);
          return events;
        });
      });
      if (mounted) {
        Navigator.pop(context, "Event added successfully");
      }
    });
  }

  void _updateEvent(Event updatedEvent, BuildContext context) {
    EventService.updateEvent(updatedEvent).catchError((e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Zamknij',
                    )),
              ],
            )
          ],
          title: const Text('Error occurred'),
          content: Text(e is Error ? e.text : 'Unexpected error occurred'),
          contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      );
      return null;
    }).then((event) {
      Event? updatedEvent = event;
      if (updatedEvent == null) {
        return;
      }
      setState(() {
        futureEvents = futureEvents.then((events) {
          int index = events
              .indexWhere((event) => event.eventId == updatedEvent.eventId);
          if (index != -1) {
            events[index] = updatedEvent;
          }
          return events;
        });
      });
      if (mounted) {
        Navigator.pop(context, "Event updated successfully");
      }
    });
  }

  void _deleteEvent(Event event) async {
    try {
      await EventApi().deleteEvent(event.eventId);
      setState(() {
        futureEvents = futureEvents.then((events) {
          events.removeWhere((e) => e.eventId == event.eventId);
          return events;
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = e is Error ? e.text : 'Unexpected error occurred';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Planner'),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        leading: DrawerButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventForm(
                    onSave: (newEvent) {
                      _addEvent(newEvent, context);
                    },
                  ),
                ),
              );
              if (result != null && result is String) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateBar(),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: futureEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  if (snapshot.error is Error) {
                    errorMessage = (snapshot.error as Error).text;
                  } else {
                    errorMessage = 'Unexpected error occurred';
                  }
                  return Center(child: Text(errorMessage!));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No events found'));
                } else {
                  List<Event> eventsForSelectedDay = snapshot.data!;
                  eventsForSelectedDay.sort((a, b) =>
                      a.startingTime.hour.compareTo(b.startingTime.hour) != 0
                          ? a.startingTime.hour.compareTo(b.startingTime.hour)
                          : a.startingTime.minute
                              .compareTo(b.startingTime.minute));
                  return ListView.builder(
                    itemCount: eventsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      Event event = eventsForSelectedDay[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetails(
                                event: event.toMap(),
                                onDelete: () {
                                  _deleteEvent(event);
                                },
                                onUpdate: (updatedEvent) {
                                  _updateEvent(updatedEvent, context);
                                },
                              ),
                            ),
                          );
                          if (result != null && result is String) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.blue, width: 2.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                event.description ?? '',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '${event.startingTime.format(context)} - ${event.endingTime.format(context)}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBar() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(Duration(days: 1));
              });
              _refreshEvents();
            },
          ),
          Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(Duration(days: 1));
              });
              _refreshEvents();
            },
          ),
        ],
      ),
    );
  }
}
