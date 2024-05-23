import 'package:flutter/material.dart';
import 'LoginPage.dart';
class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text('Imię i nazwisko'),
              accountEmail: const Text('adres@domena.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                'assets/blank-profile-picture.jpg',
                fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xffa4bf41)
            ),
          ),
          ListTile(
            leading: const Icon(
                Icons.add
            ),
            title: const Text('Dodaj do planu'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
                Icons.edit_calendar_rounded
            ),
            title: const Text('Edytuj plan'),
            onTap: () {},
          ),
          Divider(
            height: 20,
            color: Colors.grey[300],
          ),
          ListTile(
            leading: const Icon(
                Icons.add_circle
            ),
            title: const Text('Dodaj wydarzenie'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
                Icons.edit
            ),
            title: const Text('Edytuj wydarzenia'),
            onTap: () {},
          ),
          Divider(
            height: 20,
            color: Colors.grey[300],
          ),
          ListTile(
            leading: const Icon(
                Icons.logout
            ),
            title: const Text('Wyloguj się'),
            onTap: () {
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
                              )
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginPage())
                                );
                              },
                              child: const Text(
                                  'Wyloguj',
                              ),
                          ),
                        ],
                      )
                    ],
                    title: const Text('Wylogowanie'),
                    content: const Text('Czy na pewno chcesz się wylogować?'),
                    contentTextStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    ),
                  ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
                Icons.delete_forever_rounded,
              color: Colors.red,
            ),
            title: const Text(
                'Usuń konto',
            style: TextStyle(
              color: Colors.red
            ),
            ),
            onTap: () {
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
                              child: const Text('Nie'),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                                          },
                                          child: const Text('Zamknij'),
                                      ),
                                    ],
                                    title: const Text('Sukces'),
                                    content: const Text('Twoje konto zostało usunięte. Zaraz nastąpi wylogowanie'),
                                    contentTextStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                    ),
                                  )
                              );
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: Text(
                                'Tak',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                        ],
                      )
                    ],
                    title: const Text('Usuwanie konta'),
                    content: const Text('Czy na pewno chcesz usunąć swoje konto na stałe?'),
                    contentTextStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black
                    ),
                  ),
              );
            },
          ),
        ],
      ),
    );
  }


}
