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
              accountName: Text('Imię i nazwisko'),
              accountEmail: Text('adres@domena.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                'assets/blank-profile-picture.jpg',
                fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xffa4bf41)
            ),
          ),
          ListTile(
            leading: Icon(
                Icons.add
            ),
            title: Text('Dodaj do planu'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
                Icons.edit_calendar_rounded
            ),
            title: Text('Edytuj plan'),
            onTap: () {},
          ),
          Divider(
            height: 20,
            color: Colors.grey[300],
          ),
          ListTile(
            leading: Icon(
                Icons.add_circle
            ),
            title: Text('Dodaj wydarzenie'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
                Icons.edit
            ),
            title: Text('Edytuj wydarzenia'),
            onTap: () {},
          ),
          Divider(
            height: 20,
            color: Colors.grey[300],
          ),
          ListTile(
            leading: Icon(
                Icons.logout
            ),
            title: Text('Wyloguj się'),
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
                              child: Text(
                                  'Zamknij',
                              )
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage())
                                );
                              },
                              child: Text(
                                  'Wyloguj',
                              ),
                          ),
                        ],
                      )
                    ],
                    title: Text('Wylogowanie'),
                    content: Text('Czy na pewno chcesz się wylogować?'),
                    contentTextStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    ),
                  ),
              );
            },
          ),
          ListTile(
            leading: Icon(
                Icons.delete_forever_rounded,
              color: Colors.red,
            ),
            title: Text(
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
                              child: Text('Nie'),
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
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                                          },
                                          child: Text('Zamknij'),
                                      ),
                                    ],
                                    title: Text('Sukces'),
                                    content: Text('Twoje konto zostało usunięte. Zaraz nastąpi wylogowanie'),
                                    contentTextStyle: TextStyle(
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
                    title: Text('Usuwanie konta'),
                    content: Text('Czy na pewno chcesz usunąć swoje konto na stałe?'),
                    contentTextStyle: TextStyle(
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
