// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VenueChatPage extends StatefulWidget {
  final String artistId;
  final String sellerId;
  final String productId;
  final dynamic data;

  const VenueChatPage({super.key, 
    required this.artistId,
    required this.sellerId,
    required this.productId,
    required this.data,
  });

  @override
  _VenueChatPageState createState() => _VenueChatPageState();
}

class _VenueChatPageState extends State<VenueChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firestore
        .collection('chats')
        .where('artistId', isEqualTo: widget.artistId)
        .where('sellerId', isEqualTo: widget.sellerId)
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('venues').doc(widget.sellerId).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productId': widget.productId,
        'artistName':widget.data['artistName'],
        'artistPhoto': widget.data['artistPhoto'],
        'sellerPhoto': (userDoc.data() as Map<String, dynamic>)['storeImage'],
        'artistId': widget.artistId,
        'sellerId': widget.sellerId,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages.'),
                  );
                }

                return ListView(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String message = data['message'].toString();
                    String senderId = data['senderId']
                        .toString(); // Assuming 'senderId' field exists

                    // Determine if the sender is the artist or the seller
                    bool isartist = senderId == widget.artistId;
                    String senderType = isartist ? 'artist' : 'Seller';
                    bool isSellerMessage =
                        senderId == FirebaseAuth.instance.currentUser!.uid;

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: isSellerMessage
                            ? NetworkImage(data['sellerPhoto'])
                            : NetworkImage(data['artistPhoto']),
                      ),
                      title: Text(message),
                      subtitle: Text('Sent by $senderType'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
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