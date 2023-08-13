
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:student_care/src/model/UserModel.dart';

import '../services/auth_service.dart';
import 'central_state.dart';

class UserController extends ChangeNotifier{

 UserModel? userModel;
  init()async{
    centralState.startLoading();
    final check= await AuthService().findUserById(FirebaseAuth
        .instance.currentUser
    !.uid);
    if(check !=null){


      userModel = check;
    }
    print('userrr $userModel');
    centralState.stopLoading();
    notifyListeners();
  }
}

UserController userController = UserController();