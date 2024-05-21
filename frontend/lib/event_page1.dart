import 'package:flutter/material.dart';


class EventPage1 extends StatelessWidget {
  const EventPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dni wydziału',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: const Color(0xff49D3F2),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Data i godzina: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '05.04.2024 r. 08:15 - 10:45',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Miejsce: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'WEEIA ul. Stefanowskiego 18/22',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  'Opis wydarzenia',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                  ),
                ),
              ),
              Expanded(
                  child:
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 3,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent id eros magna. Donec lobortis viverra lacus, sit amet commodo ipsum egestas pretium. Ut vestibulum lectus est, eu efficitur urna pulvinar eu. Sed vitae elit auctor, lobortis tortor nec, suscipit eros. Nulla lobortis blandit mi, ut dignissim mi vehicula ut. Praesent sollicitudin ante odio. Nulla sollicitudin, diam eu rutrum bibendum, nunc diam vehicula tortor, quis fringilla mauris ligula vel ligula. Cras rutrum nulla at lectus venenatis maximus.',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                    )
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff49D3F2),
                    elevation: 5.0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(10)
                    ),
                  ),
                  child: Text(
                    'Dodaj do kalendarza',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
