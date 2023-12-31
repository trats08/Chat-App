import 'package:chattie/pages/auth/group_info.dart';
import 'package:chattie/services/database_service.dart';
import 'package:chattie/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({Key? key, required this.groupId,required this.groupName, required this.userName}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }
  getChatandAdmin(){
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
      DatabaseService().getGroupAdmin(widget.groupId).then((val) {
        setState(() {
          admin=val;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
          title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, GroupInfo(groupName: widget.groupName, groupId: widget.groupId, adminName: admin));},
              icon: Icon(Icons.info))
        ],
      ),
    );
  }
}
