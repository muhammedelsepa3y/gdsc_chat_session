import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/user_provider.dart';

class ChatScreen extends StatefulWidget {
final  String uid;
final  String name;
final String image;
  const ChatScreen({
    required this.uid,
    required this.name,
    required this.image,
});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.image),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.name),
              ],
            ),

            Expanded(
              child:
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Chats').doc(widget.uid).collection('Messages').orderBy('time',descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map((
                          DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<
                            String,
                            dynamic>;
                        bool isMe = data['from'] == FirebaseAuth.instance.currentUser!.uid;
                        return Row(
                          mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isMe?Colors.blue:Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(data['message'],style: const TextStyle(color: Colors.white),),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(),);
                }
              )
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: userProvider.messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      userProvider.sendMessage(widget.uid);
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

