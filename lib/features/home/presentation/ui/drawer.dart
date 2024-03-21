import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final String profilePicUrl;
  const CustomDrawer({
    super.key,
    required this.accountName,
    required this.accountEmail,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(color: Colors.black),
            child: UserAccountsDrawerHeader(
              arrowColor: Colors.black,
              decoration: const BoxDecoration(color: Colors.black),
              margin: EdgeInsets.zero,
              currentAccountPicture: CircleAvatar(
                radius: 32,
                foregroundImage: NetworkImage(profilePicUrl),
              ),
              accountName: Text(
                accountName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                accountEmail,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade800,
            ),
          )
        ],
      ),
    );
  }
}
