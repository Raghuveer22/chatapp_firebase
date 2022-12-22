import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName})
      : super(key: key);
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(groupName: widget.groupName, groupId: widget.groupId, userName: widget.userName ,));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color:Colors.white),),
          ),
          title: Text(widget.groupName,style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.userName}",style: const TextStyle(fontSize: 13),),
        ),
      ),
    );
  }
}
