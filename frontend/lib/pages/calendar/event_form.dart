import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  final Event? initialEvent;
  final Function(Event) onSave;

  EventForm({this.initialEvent, required this.onSave});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late int _userID;
  late String _name;
  late String? _description;
  late String? _place;
  late EventType _eventType;
  late DateTime _dateStart;
  late DateTime _dateEnd;
  late TimeOfDay _startingTime;
  late TimeOfDay _endingTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      _userID = widget.initialEvent!.userID;
      _name = widget.initialEvent!.name;
      _description = widget.initialEvent!.description;
      _place = widget.initialEvent!.place;
      _eventType = widget.initialEvent!.eventType;
      _dateStart = widget.initialEvent!.dateStart;
      _dateEnd = widget.initialEvent!.dateEnd;
      _startingTime = widget.initialEvent!.startingTime;
      _endingTime = widget.initialEvent!.endingTime;
    } else {
      _userID = 0;
      _name = '';
      _description = '';
      _place = '';
      _eventType = EventType.SINGLE;
      _dateStart = DateTime.now();
      _dateEnd = DateTime.now();
      _startingTime = TimeOfDay.now();
      _endingTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialEvent == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(
                    label: 'Event Name',
                    initialValue: _name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  _buildTextField(
                    label: 'Description',
                    initialValue: _description,
                    maxLines: 5,  // To make the description box larger
                    onSaved: (value) {
                      _description = value;
                    },
                  ),
                  _buildTextField(
                    label: 'Place',
                    initialValue: _place,
                    onSaved: (value) {
                      _place = value;
                    },
                  ),
                  _buildDropdownField(
                    label: 'Event Type',
                    value: _eventType,
                    onChanged: (value) {
                      setState(() {
                        _eventType = value!;
                      });
                    },
                    items: EventType.values.map((type) {
                      return DropdownMenuItem<EventType>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DatePickerFormField(
                          initialValue: _dateStart,
                          label: 'Start Date',
                          onDateSelected: (date) {
                            setState(() {
                              _dateStart = date;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DatePickerFormField(
                          initialValue: _dateEnd,
                          label: 'End Date',
                          onDateSelected: (date) {
                            setState(() {
                              _dateEnd = date;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TimePickerFormField(
                          initialValue: _startingTime,
                          label: 'Starting Time',
                          onTimeSelected: (time) {
                            setState(() {
                              _startingTime = time;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TimePickerFormField(
                          initialValue: _endingTime,
                          label: 'Ending Time',
                          onTimeSelected: (time) {
                            setState(() {
                              _endingTime = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Event newEvent = Event(
                          eventId: widget.initialEvent?.eventId ?? 0,
                          userID: _userID,
                          name: _name,
                          description: _description,
                          place: _place,
                          eventType: _eventType,
                          dateStart: _dateStart,
                          dateEnd: _dateEnd,
                          startingTime: _startingTime,
                          endingTime: _endingTime,
                        );
                        widget.onSave(newEvent);
                        Navigator.pop(context, "Event ${widget.initialEvent == null ? 'added' : 'updated'} successfully");
                      }
                    },
                    child: Text(widget.initialEvent == null ? 'Add' : 'Update'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required ValueChanged<T?> onChanged,
    required List<DropdownMenuItem<T>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}

class DatePickerFormField extends StatelessWidget {
  final DateTime initialValue;
  final String label;
  final ValueChanged<DateTime> onDateSelected;

  DatePickerFormField({required this.initialValue, required this.label, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialValue,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(DateFormat('yyyy-MM-dd').format(initialValue)),
      ),
    );
  }
}

class TimePickerFormField extends StatelessWidget {
  final TimeOfDay initialValue;
  final String label;
  final ValueChanged<TimeOfDay> onTimeSelected;

  TimePickerFormField({required this.initialValue, required this.label, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: initialValue,
        );
        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(initialValue.format(context)),
      ),
    );
  }
}
