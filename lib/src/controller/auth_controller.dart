import 'package:flutter/material.dart';
import 'package:student_care/main.dart';
import 'package:student_care/src/controller/user_controller.dart';
import 'package:student_care/src/model/UserModel.dart';
import 'package:student_care/src/services/auth_service.dart';
import 'package:student_care/src/utils/reusable_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../views/authentication/login.dart';
import '../views/home/base.dart';
import 'package:http/http.dart' as http;
class AuthController extends ChangeNotifier{
  bool load = false;
  AuthService authService = AuthService();
  TextEditingController emailController= TextEditingController();
  TextEditingController userNameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController regNoController= TextEditingController();
  Future signIn()async{

    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      showToast("Complete all fields");
      return;
    }
    load = true;
    notifyListeners();
    final user = await authService.signIn(email: emailController.text.trim(),password: passwordController.text.trim());
    if(user==false){
      load = false;
      notifyListeners();
      return;
    }
    await userController.init();
    await sendEmail("Hello ${userController.userModel!.userName!}, you just signed into your account on CCU Welfare Care");

    load = false;
    notifyListeners();
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>const Base(),),(route)=>false);

    // Navigator.pushNamedAndRemoveUntil(navigatorKey!
    //     .currentContext!, Base.id, (route) => false);
  }


  Future signUp({String? email,String? password})async{
    if(emailController.text.isEmpty || passwordController.text.isEmpty || regNoController.text.isEmpty|| userNameController.text.isEmpty){
      showToast("Complete all fields");
      return;
    }
    load = true;
    notifyListeners();
    final username = await authService.findUserUsername(userNameController.text.trim());

    if(username == true){
      load = false;
      notifyListeners();
      showToast("username is in use already");

      return;
    }

    final user = await authService.signUp(email: emailController.text.trim(),password: passwordController.text.trim());
    if(user == null){
      load = false;
      notifyListeners();

      return;
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    UserModel userModel=UserModel(
      email: emailController.text.trim(),
      regNo: regNoController.text.trim(),
      userName: userNameController.text.trim(),
      department: null,
      level: null,
      fcmToken:fcmToken ,
      profilePicture: null,
      createdAt: DateTime.now(),
      userId: user.uid,
    );

    final createUser =  await authService.createUser(userModel);
    if(createUser  == null){
      load = false;
      notifyListeners();
      return;
    }
    await sendEmail("Hello ${userNameController.text} \n Welcome to CCU Welfare Care, Your account has been created successfully");
    // await userController.init();
     load = false;
    notifyListeners();
    Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>const Login(),),(route)=>false);

  }
   Future sendEmail(String message,{ String? email })async {
    try {
      final response = await http.post(
          Uri.parse('https://email-service-fsmn.onrender.com/mail'), body: {
        "name": "CCU Welfare Care",
        "receiver": email!,
        "message": "${message}",
        "sender": "Consultant@gmail.com"
      });
      print(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

}