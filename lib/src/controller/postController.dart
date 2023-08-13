import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:student_care/src/controller/auth_controller.dart';
import 'package:student_care/src/controller/image_controller.dart';
import 'package:student_care/src/controller/user_controller.dart';
import 'package:student_care/src/model/PostModel.dart';
import 'package:student_care/src/services/post_service.dart';
import 'package:student_care/src/utils/reusable_widget.dart';

import '../../main.dart';
import '../model/UserModel.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';

class PostController extends ChangeNotifier{

  TextEditingController postController = TextEditingController();
  bool load = false;
  bool isAnonymous = false;

  changePostVisibility(bool newValue){
    isAnonymous = newValue;
    notifyListeners();
  }
  Future createPost(ImageController imageController)async{
load = true;
notifyListeners();
    if(imageController.imageFiles.isNotEmpty){
      await imageController.uploadImage();
    }
    Poster poster= Poster(
      userId: userController.userModel!.userId,
      email: userController.userModel!.email,
      username: userController.userModel!.userName,
      profilePic: userController.userModel!.profilePicture,
    );
Poster anonymousPoster= Poster(
  userId: userController.userModel!.userId,
  email:"anonymous",
  username: "anonymous",
  profilePic: null,
);
    PostModel post = PostModel(
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      status: PostStatus.pending,
      content: postController.text.trim(),
      picture:imageController.imageUrlList,
      poster:isAnonymous?anonymousPoster:poster,
    );
    final result = await PostService.createPost(post);
    if(result == null){
      load = true;
      notifyListeners();
      showToast("Unable to create post");
    }


showToast("Notifying users...");
for(var users in userList){
  if(users.email != poster.email){
    await AuthController().sendEmail("Hello ${users.userName} ${poster.username} made a new post on CCU Welfare Care ",email: users.email);

  }
}
load = false;
notifyListeners();

Navigator.pop(navigatorKey.currentState!.context);
Alert(
  context: navigatorKey.currentState!.context,
  type: AlertType.success,
  title: "",
  desc: "Post created successfully",
  buttons: [
    DialogButton(
      color: AppTheme.primary,
      child: Text(
        "Great",
        style: TextStyle(color: AppTheme.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(navigatorKey.currentState!.context),
      width: 120,
    )
  ],
).show();

  }

  List<UserModel> userList = [];
  Future getAllUsers()async{

    UserService.getAllUsers()!.listen((event) {
      userList.clear();

      event.forEach((element) => userList!.add(element));

      print(userList
      );
      notifyListeners();
      // onSearchForConsultants(searchString!);
      notifyListeners();

    });

  }
  getAllConsultant(){

  }
  List<PostModel> postList = [];
  List<PostModel> postListSearchable = [];
  String? searchString = '';
  getAllPost()async{
    PostService.getAllPost()!.listen((event) {
      postList.clear();
      event.forEach((element) => postList!.add(element));
      print(postList);
      notifyListeners();
      onSearchForConsultants(searchString!);
      notifyListeners();

    });
  }


  onSearchForConsultants(String search) {
    searchString = search.toLowerCase();
    notifyListeners();

    postListSearchable.clear();
    if (searchString == '' ||  searchString == null) {
      print(postList);
      postList!.forEach(
              (PostModel element) =>postListSearchable.add(element));
      notifyListeners();
    } else {
      postList
      !.forEach((PostModel? consultantModel) {

        // if (consultantModel
        // !.firstName!
        //     .toLowerCase()
        //     .contains(searchString!) || consultantModel!.lastName!
        //     .toLowerCase()
        //     .contains(searchString!)) {
        //   consultantListSearchable.add(consultantModel!);
        //   notifyListeners();
        // }

      });
    }
  }
}



class PostStatus{
  //static String resolved='resolved';
  static String pending='pending';
  static String inReview='In Review';
  static String approved ='Approved';
}