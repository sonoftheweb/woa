import 'package:flutter/material.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/services/auth/auth_service.dart';

class SideNavMenuItems {
  BuildContext context;

  SideNavMenuItems({Key? key, required this.context});

  List<Widget> menuList() {
    return [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: Text('home'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.timelapse_rounded),
        title: Text('history'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.auto_graph_outlined),
        title: Text('stats'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.edit_note_outlined),
        title: Text('workout plans'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.settings_outlined),
        title: Text('settings'.toUpperCase()),
        onTap: () => {},
      ),
      Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height - 500,
            ),
            child: ListTile(
              leading: const Icon(Icons.upload),
              title: Text('share'.toUpperCase()),
              onTap: () => {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.toUpperCase()),
            onTap: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
          ),
        ],
      ),
    ];
  }
}
