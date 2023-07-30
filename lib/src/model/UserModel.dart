class UserModel{
  String? email;
  String? regNo;
  String? userId;
  String? department;
  DateTime? createdAt;
  String? level;
  String?userName;
  String? profilePicture;
  UserModel({this.email,this.createdAt,this.userId,this.userName,this.department,this.level,this.profilePicture,this.regNo});
 UserModel.fromJson(Map<String,dynamic> data){
   email = data['email'];
   userId=data['userId'];
   regNo=data['regNo'];
   department = data['department'];
   level = data['level'];
   profilePicture=data['profilePic'];
   userName = data['userName'];

 }
  Map<String,dynamic> toJson(){
   Map<String,dynamic> data={};
     data['email']=email;
  data['userId']= userId;
  data['regNo']=regNo;
    data['department']= department;
   data['level']= level;
 data['profilePic']=  profilePicture;
 data['userName']=userName;
 return data;
 }

}