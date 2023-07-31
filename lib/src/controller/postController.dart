import 'package:flutter/cupertino.dart';
import 'package:student_care/src/controller/image_controller.dart';
import 'package:student_care/src/controller/user_controller.dart';
import 'package:student_care/src/model/PostModel.dart';
import 'package:student_care/src/services/post_service.dart';
import 'package:student_care/src/utils/reusable_widget.dart';

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
    PostModel post = PostModel(
      createdAt: DateTime.now(),
      status: PostStatus.pending,
      content: postController.text.trim(),
      picture:imageController.imageUrlList,
      poster:poster,
    );
    final result = await PostService.createPost(post);
    if(result == null){
      load = true;
      notifyListeners();
      showToast("Unable to create post");
    }
load = false;
notifyListeners();
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



class PostStatus {
  static String pending ='pending';
  static String inReview= 'inReview';
  static String resolved = 'resolved';
}