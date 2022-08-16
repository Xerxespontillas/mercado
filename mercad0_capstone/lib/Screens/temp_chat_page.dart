import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Models/chat_users_model.dart';

import '../Widgets/conversation_list.dart';
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}
 
class _ChatPageState extends State<ChatPage> {
   List<ChatUsers> chatUsers = [
    ChatUsers(name: "Fisher Folks", messageText: "Hello guys, we have", imageURL: "https://media.istockphoto.com/photos/happy-craftsman-picture-id1367037181?k=20&m=1367037181&s=612x612&w=0&h=YKVnL4_AP-77jYqzYSQzT7S65etGv-KkQm18ev0X118=", time: "Yesterday"),
    ChatUsers(name: "Ric", messageText: "Hi guys, nice to meet you!", imageURL: "https://media.istockphoto.com/photos/moken-sea-gypsie-picture-id174546300?k=20&m=174546300&s=612x612&w=0&h=5Ee2eu0dpBvFOvhRP6atjclWK0aTDOIfxLApOYoe1aM=", time: "5:10 PM"),
    ChatUsers(name: "John Mark", messageText: "What's the plan?", imageURL: "https://media.istockphoto.com/photos/squinting-mature-man-picture-id648596804?k=20&m=648596804&s=612x612&w=0&h=wzVXEYzMzJSTOKXcPmNmoGT7GjLk8SM9wg0cTh32KpY=", time: "Yesterday"),
    ChatUsers(name: "Angelo Maglasang", messageText: "I'm working on it", imageURL: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60", time: "Yesterday"),
  ];
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child:ListView.builder(
  itemCount: chatUsers.length,
  shrinkWrap: true,
  padding: EdgeInsets.only(top: 16),
  physics: NeverScrollableScrollPhysics(),
  itemBuilder: (context, index){
    return ConversationList(
      name: chatUsers[index].name,
      messageText: chatUsers[index].messageText,
      imageUrl: chatUsers[index].imageURL,
      time: chatUsers[index].time,
      isMessageRead: (index == 0 || index == 3)?true:false,
    );
  },
),
    );
  }
  
}
