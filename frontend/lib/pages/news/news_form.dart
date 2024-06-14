import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/calendar/event_form.dart';

import '../../models/news.dart';

class NewsForm extends StatefulWidget {
  final News? initNews;
  final Function(News) onSave;

  NewsForm({this.initNews, required this.onSave});

  @override
  State<NewsForm> createState() => _NewsFormState();
}

class _NewsFormState extends State<NewsForm> {
  final formKey = GlobalKey<FormState>();
  late int userId;
  late String name;
  late String? description;
  late String place;
  late DateTime dateOfEvent;
  late DateTime dateAdded;
  late TimeOfDay startingTime;
  late TimeOfDay endingTime;

  @override
  void initState(){
    super.initState();
    if(widget.initNews == null){
      userId = 0;
      name = '';
      description = '';
      place = '';
      dateOfEvent = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      dateAdded = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      startingTime = TimeOfDay(
          hour: TimeOfDay.now().hour,
          minute: TimeOfDay.now().minute,
      );
      endingTime = TimeOfDay(
        hour: TimeOfDay.now().hour,
        minute: TimeOfDay.now().minute + 1,
      );
    }
    else{
      userId = widget.initNews!.userId;
      name = widget.initNews!.name;
      description = widget.initNews!.description;
      place = widget.initNews!.place;
      dateAdded = widget.initNews!.dateAdded!;
      dateOfEvent = widget.initNews!.dateOfEvent;
      startingTime = widget.initNews!.startingTime;
      endingTime = widget.initNews!.endingTime;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.initNews == null ? 'Add News' : 'Edit News'),
    ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: 'News name'
                ),
                validator: (enteredValue){
                  if(enteredValue == null || enteredValue.isEmpty){
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (enteredValue){
                  name = enteredValue!;
                },
              ),
              TextFormField(
                initialValue: place,
                decoration: InputDecoration(
                    labelText: 'Place'
                ),
                validator: (enteredValue){
                  if(enteredValue == null || enteredValue.isEmpty){
                    return 'Please enter a place';
                  }
                  return null;
                },
                onSaved: (enteredValue){
                  place = enteredValue!;
                },
              ),
              TextFormField(
                initialValue: description,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: 'Description'
                ),
                onSaved: (enteredValue) {
                  description = enteredValue;
                },
              ),
              SizedBox(
                height: 16,
              ),
              DatePickerFormField(
                  initialValue: dateOfEvent,
                  label: 'News date',
                  onDateSelected: (date){
                    setState(() {
                      dateOfEvent = date;
                    });
                  }
              ),
              SizedBox(
                height: 16,
              ),
              TimePickerFormField(
                  initialValue: startingTime,
                  label: 'Starting time',
                  onTimeSelected: (time){
                    setState(() {
                      startingTime = time;
                    });
                  }
                ),
              SizedBox(
                height: 16,
              ),
              TimePickerFormField(
                  initialValue: endingTime,
                  label: 'Ending time',
                  onTimeSelected: (time){
                    setState(() {
                      endingTime = time;
                    });
                  }
              ),
              SizedBox(
                  height: 20
              ),
              ElevatedButton(
                  onPressed: (){
                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();
                  News createdNews = News(
                    newsId: widget.initNews?.newsId ?? 0,
                    userId: userId,
                    name: name,
                    description: description,
                    place: place,
                    dateAdded: dateAdded,
                    dateOfEvent: dateOfEvent,
                    startingTime: startingTime,
                    endingTime: endingTime
                  );
                  widget.onSave(createdNews);
                }
              },
                  child: Text(
                    widget.initNews == null ? 'Add News' : 'Update News',
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
