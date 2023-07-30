import 'package:flutter/material.dart';
import 'package:student_care/main.dart';
import 'package:student_care/src/controller/user_controller.dart';
import 'package:student_care/src/model/UserModel.dart';
import 'package:student_care/src/services/auth_service.dart';
import 'package:student_care/src/utils/reusable_widget.dart';

import '../views/authentication/login.dart';
import '../views/base.dart';

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
    final user = await authService.signUp(email: emailController.text.trim(),password: passwordController.text.trim());
    if(user == null){
      load = false;
      notifyListeners();

      return;
    }

    UserModel userModel=UserModel(
      email: emailController.text.trim(),
      regNo: regNoController.text.trim(),
      userName: userNameController.text.trim(),
      department: null,
      level: null,
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
    // await userController.init();
     load = false;
    notifyListeners();
    Navigator.pushAndRemoveUntil(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>const Login(),),(route)=>false);

  }


}