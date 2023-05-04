import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String photoUrl;

  User({
    required this.id,
    required this.name,
    required this.photoUrl,
  });
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  void _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      _isLoading = false;
      _users = snapshot.docs
          .map((doc) => User(
                id: doc.id,
                name: doc['name'],
                photoUrl: doc['photoUrl'],
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for users",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchUsers(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else if (_users.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  User user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    title: Text(user.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientId: user.id,
                            recipientName: user.name,
                            recipientPhotoUrl: user.photoUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else
            Center(
              child: Text("No users found"),
            ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String recipientPhotoUrl;

  const ChatScreen({
    Key? key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientPhotoUrl,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late String _currentUserId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final user = await _db.collection('users').doc().get();
    setState(() {
      _currentUserId = user.id;
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _db.collection('messages').add({
        'sender_id': _auth.currentUser!.uid,
        'receiver_id': widget.recipientId,
        'content': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('messages')
                  .where('sender_id',
                      whereIn: [_currentUserId, widget.recipientId])
                  .where('receiver_id',
                      whereIn: [_currentUserId, widget.recipientId])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['content']),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
