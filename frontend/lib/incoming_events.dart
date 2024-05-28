import 'package:flutter/material.dart';

import 'event_page1.dart';
import 'event_page2.dart';

class IncomingEvents extends StatefulWidget {
  const IncomingEvents({super.key});

  @override
  State<IncomingEvents> createState() => _IncomingEventsState();
}

class _IncomingEventsState extends State<IncomingEvents> {
  int nextIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nadchodzące wydarzenia',
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body:
          Container(
            color: Colors.white,
            child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 3,
                    radius: const Radius.circular(10),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(7, 0, 7, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                                child: const Text(
                                  'Dziś',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => const EventPage1())
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: const Color(0xff49D3F2),
                                          minimumSize: const Size(0, 80)
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '08:15',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                Text(
                                                  '10:45',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Dni wydziału',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  'WEEIA',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                          )
                                        ],
                                      ))),
                              Divider(
                                color: Colors.grey[100],
                                height: 30,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(bottom: 10),
                                child: const Text(
                                  '10 czerwca 2024',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => const EventPage2())
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: const Color(0xff49D3F2),
                                          minimumSize: const Size(0, 80)
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '16:15',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                Text(
                                                  '19:25',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Webinar',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  'Biuro karier',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                )
            ),
          )
    );
  }
}
