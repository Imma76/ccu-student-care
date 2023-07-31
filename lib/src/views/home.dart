import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_care/src/controller/postController.dart';
import 'package:student_care/src/model/PostModel.dart';
import 'package:student_care/src/provider/all_provider.dart';

import '../theme/app_theme.dart';
import 'new_post.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(postProvider
    );
    ref.read(postProvider).getAllPost();
  }
  @override
  Widget build(BuildContext context) {

    PostController postController = ref.watch(postProvider);
    return Scaffold(
      floatingActionButton:FloatingActionButton(onPressed: (){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewPost()));

      },child: Icon(Icons.add,),backgroundColor: AppTheme.primary,),
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 300,
        leading: Text('Timeline',style: GoogleFonts.poppins(fontSize:30 ,color: AppTheme.black),),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
              itemCount: postController.postList.length,
              itemBuilder: (context,index){
            return      PostWidget(postModel: postController.postList[index],);
          })

        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
 final PostModel? postModel;
  const PostWidget({
    super.key,this.postModel
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        color: Colors.white,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              const CircleAvatar(radius:15,child: Icon(Icons.person),),
              Gap(10),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text('${postModel!.poster!.username}',style: GoogleFonts.poppins(fontSize:10,fontWeight:

                  FontWeight.bold),),
                  Text('1 hour ago',style: GoogleFonts.poppins(fontSize:7 ),),


                ],
              ),
              Spacer(),
              Container(

                decoration: BoxDecoration(borderRadius: BorderRadius
                .circular(5),  color: Colors.grey,),
                child: Align(
                  alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text('Pending',style: GoogleFonts.poppins(fontSize:10 ),),
                    )),
              ),
            ],
          ),
            Gap(6),
          Text('${postModel!.content}'),
            Spacer(
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){
                  showModalBottomSheet(context: context, builder: (context)=> Container());
                },
                child: Icon(Icons.comment,size:

                  15,),
              ),
            )
        ],),
      ),
    );
  }
}
