import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Hello"),
            Text("User"),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {},
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white54,
            foregroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),
        ),
      ],
    );
  }
}
