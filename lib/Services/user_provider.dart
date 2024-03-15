
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gdsc_chat_session/Screens/chat/chat.dart';

import '../Components/flush_bar.dart';
import '../Screens/home/home_screen.dart';
import 'navigation_service.dart';

class UserProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController searchControllerUsers = TextEditingController();
  bool secure = true;

  setSecure() {
    secure = !secure;
    notifyListeners();
  }
  bool secure2 = true;
  setSecure2() {
    secure2 = !secure2;
    notifyListeners();
  }
  disposeAlldata(){
    emailController.text="";
    passwordController.text="";
    nameController.text="";
    familyNameController.text="";
    phoneController.text="";
    ageController.text="";
    confirmPasswordController.text="";
    searchControllerUsers.text="";
    secure2=true;
    secure=true;
    notifyListeners();
  }
  login() async {
    EasyLoading.show(status: 'loading...');
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).then((value) async
    {

      EasyLoading.dismiss();
      Navigator.of(NavigationService.context!).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen()));
      disposeAlldata();

    }).
    catchError((e){

      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        showFlushBar("No user found for that email");
      }
      else if (e.code == 'wrong-password') {
        showFlushBar("Wrong password provided for that user");
      } else if(e.code=="invalid-email"){
        showFlushBar("Invalid Email");
      }else if(e.code=="invalid-credential"){
        showFlushBar("Invalid Credential");
      }
      else{
        showFlushBar("Something went wrong ${e.code}");
      }
    });
  }
  signup() async  {
    EasyLoading.show(status: 'loading...',);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "name": nameController.text,
        "familyName": familyNameController.text,
        "phone": phoneController.text,
        "age": ageController.text,
        "email": emailController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "image":"https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"
      });

      EasyLoading.dismiss();
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(NavigationService.context!, MaterialPageRoute(builder: (context) => HomeScreen()));
        showFlushBar("Account Created Successfully",isError: false);
        disposeAlldata();
      });
    } on FirebaseException catch (e)  {
      EasyLoading.dismiss();
      if (e.code == 'weak-password') {
        showFlushBar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showFlushBar("The account already exists for that email.");
      }
      else {
        showFlushBar("Something went wrong ${e.code}");
      }
    }
  }
  bool loading=false;
  setLoading(bool val){
    loading=val;
    notifyListeners();
  }
  List allUsers=[];
  List filteredUsers=[];
  getAllUsers(){
    setLoading(true);
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      allUsers=value.docs.where((element) => element.id != FirebaseAuth.instance.currentUser!.uid).toList();
      filteredUsers=allUsers;
      setLoading(false);
      notifyListeners();
    }).catchError((e){
      setLoading(false);
      showFlushBar("Something went wrong ${e.toString()}");
    });
  }

  void searchUsers  () {
    filteredUsers = allUsers.where((element) => element['name'].toString().toLowerCase().contains(searchControllerUsers.text.toLowerCase())).toList();
    notifyListeners();
  }

  void getChatWithUser(uid, name, image) {
    setLoading(true);
    Navigator.push(NavigationService.context!, MaterialPageRoute(builder: (context) => ChatScreen(uid: uid, name: name, image: image,)));
    getMessages(uid);

  }
TextEditingController messageController = TextEditingController();
  List messages=[];
  void getMessages(uid)async {
   var response =await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Chats").doc(uid).collection("Messages").orderBy("time",descending: true).get();
    messages=response.docs;
    notifyListeners();

  }

  void sendMessage(String uid) async{
    String message=messageController.text;
    messageController.text="";
    int time=DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Chats").doc(uid).collection("Messages").
    add({
      "message":message,
      "time":time,
      "from":FirebaseAuth.instance.currentUser!.uid,
      "to":uid
    });
    await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Chats").doc(FirebaseAuth.instance.currentUser!.uid).collection("Messages").
    add({
      "message":message,
      "time":time,
      "from":FirebaseAuth.instance.currentUser!.uid,
      "to":uid
    });
    getMessages(uid);

  }
}