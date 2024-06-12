import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import '../helpers/storage_helper.dart';
import '../models/user.dart';
import '../../models/error.dart';

class SideBar extends StatelessWidget {
  final ValueNotifier<User?> user;
  const SideBar({super.key, required this.user});

  void logout(BuildContext context) {
    Navigator.of(context).pop();
    user.value = null;
    StorageHelper.deleteAll();
  }
  void deleteAccount(BuildContext context, User userToDelete){
    var response = UserService.deleteAccount(userToDelete);
    if (response.runtimeType != Error){
      Navigator.of(context).pop();
      user.value = null;
      StorageHelper.deleteAll();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
          AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
            title: const Text('Success'),
            content: const Text(
                'Your account has been deleted. You\'re about to be signed out...'),
            contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black
            ),
          ));
      return;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
              title: const Text('Error'),
              content: Text(response.runtimeType == Error ? (response as Error).text : "Unexpected error"),
              contentTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ),
            ));
  }
  @override
  Widget build(BuildContext context) =>
    ValueListenableBuilder(valueListenable: user, builder: (BuildContext context, User? currentUser, Widget? child) =>
      Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${currentUser?.name} ${currentUser?.surname}'),
              accountEmail: Text('${currentUser?.email}'),
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
                  Icons.logout
              ),
              title: const Text('Sign out'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Close',
                                  )
                              ),
                              TextButton(
                                onPressed: () => logout(context),
                                child: const Text(
                                  'Sign out',
                                ),
                              ),
                            ],
                          )
                        ],
                        title: const Text('Signing out'),
                        content: const Text(
                            'Are you sure you want to sign out?'),
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
                'Delete account',
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteAccount(context, currentUser!);
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                        title: const Text('Delete account'),
                        content: const Text(
                            'Are you sure you want to permanently delete your account?'),
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
      )
    );
}
