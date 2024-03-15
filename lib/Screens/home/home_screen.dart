import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gdsc_chat_session/Components/input_component.dart';
import 'package:provider/provider.dart';

import '../../Services/user_provider.dart';
import '../authentication/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    userProvider.getAllUsers();


  }

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats App'),
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              userProvider.getAllUsers();

            },
            icon: const Icon(Icons.refresh),
          ),
          ElevatedButton(
              onPressed:  () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
              , child: Text('Logout'))
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children:[
            InputComponent (
              con: userProvider.searchControllerUsers,
              lab: "Search",
              pre: const Icon(Icons.search),
              oC: (p0) {
                userProvider.searchUsers();
              },
            ),
            Expanded(child:
            Provider.of<UserProvider>(context, listen: true).loading?const Center(child: CircularProgressIndicator(),):
            Provider.of<UserProvider>(context, listen: true).filteredUsers.isEmpty?const Center(child: Text("No Users Found"),):
                ListView(
                  children: userProvider.filteredUsers.map((e) => ListTile(
                    onTap: () {
                      userProvider.getChatWithUser(e['uid'], e['name'], e['image']);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(e['image']),
                    ),
                    title: Text(e['name']),
                    subtitle: Text(e['email']),
                  )).toList(),
                )

            ),


          ],
        ),
      ),
    );
  }
}
