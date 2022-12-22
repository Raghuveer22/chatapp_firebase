import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference to our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  //saving user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "profilePic": "",
      "groups": [],
      "uid": uid,
    });
  }

  //getting User Data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get User groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
  //creating groups
 Future createGroup(String userName,String id,String groupName)async{
    DocumentReference groupdocumentReference= await groupCollection.add({
      "groupName": groupName,
      "groupIcon":"",
      "admin":"${id}_$userName",
      "members":[],
      "groupId":"",
      "recentMessage":"",
      "recentMessageSender":"",
      "recentMessageTime":"",
    });
    await groupdocumentReference.update({
      "members":FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId":groupdocumentReference.id,
    });
    DocumentReference userDocumentReference=await userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });

 }
 //getting the chats
 getChats(String groupId) async{
   return groupCollection.doc(groupId)
       .collection("messages")
       .orderBy("time")
       .snapshots();
 }
 Future getGroupAdmin(String groupId)async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot =await d.get();
    return documentSnapshot['admin'];
 }
 //getting group members
  getGroupMembers(groupId)async{
    return groupCollection.doc(groupId).snapshots();
}
//search groups
searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();
}
//function-->bool
Future<bool>isUserJoined(String groupName,String groupId,String userName) async{
    DocumentReference  userDocumentReference=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot= await userDocumentReference.get();
    List<dynamic>groups= await documentSnapshot['groups'];
    if(groups.contains("${groupId}_${groupName}"))
    {
      return true;
    }
    else
      {
        return false;
      }
}
//toggling GroupJoin
Future toggleGroupJoin(String groupId,String userName,String groupName)async{
    DocumentReference  userDocumentReference=userCollection.doc(uid);
    DocumentReference groupDocumentReference=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await userDocumentReference.get();
    List<dynamic>groups=await documentSnapshot['groups'];
    //if group has our groups->then remove or in other part rejoin
    if(groups.contains("${groupId}_$groupName"))
      {
        await userDocumentReference.update({
          "groups":FieldValue.arrayRemove(["${groupId}_$groupName"]),

        });
        await groupDocumentReference.update({
          "members":FieldValue.arrayRemove(["${uid}_$userName"])
        });
      }else
        {
          await userDocumentReference.update({
            "groups":FieldValue.arrayUnion(["${groupId}_$groupName"]),
          });
          await groupDocumentReference.update({
            "members":FieldValue.arrayUnion(["${uid}_$userName"])
          });

        }
}
//database service to send the message
sendMessage(String groupId,Map<String,dynamic>chatMessageData) async{
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage":chatMessageData['message'],
      "recentMessageSender":chatMessageData['sender'],
      "recentMessageTime":chatMessageData['time'].toString(),
    });
}
}
