// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:student_care/src/controller/comment_controller.dart';
import 'package:student_care/src/controller/postController.dart';
import 'package:student_care/src/model/PostModel.dart';
import 'package:student_care/src/provider/all_provider.dart';

import '../../model/commentModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/loader.dart';
import '../new_post.dart';
import 'image_view.dart';

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
    ref.read(commentProvider);


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

      },child: const Icon(Icons.add,),backgroundColor: AppTheme.primary,),
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 300,
        leading: Text('  Timeline',style: GoogleFonts.poppins(fontSize:30 ,color: AppTheme.black),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: postController.postList.length,
                itemBuilder: (context,index){
              return      PostWidget(postModel: postController.postList[index],);
            }),
          )

        ],
      ),
    );
  }
}
class PostWidget extends ConsumerStatefulWidget {
  final PostModel?postModel;
  const PostWidget({
    Key? key,this.postModel
  }) : super(key: key);

  @override
  ConsumerState createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  List<Comments> commentList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(commentProvider);
    commentList.clear();
    ref.read(commentProvider).getAllPostComments(widget.postModel!.postId!).then((value) {
      commentList=value;
      return commentList;
    });
  }
  @override
  Widget build(BuildContext context) {
    CommentsController commentsController= ref.watch(commentProvider);
    PostController postController = ref.watch(postProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // constraints: const BoxConstraints
        //   (minHeight: 100, maxHeight: 300.0),
        height: MediaQuery.of(context).size.height/5,
        // padding: const EdgeInsets.all(8.0),

        // height: double.parse(widget.postModel!.content!.length!.toString()),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Row(
              children: [
                const CircleAvatar(radius:15,child: Icon(Icons.person),),
                const Gap(10),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text('${widget.postModel!.poster!.username}',style: GoogleFonts.poppins(fontSize:10,fontWeight:

                    FontWeight.bold),),
                    Text(DateFormat('MMMM d, h:mm a').format(widget.postModel!.createdAt!),style: GoogleFonts.poppins(fontSize:7 ),),


                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius
                      .circular(5),  color: widget.postModel!.status==Status.pending
                      ?Colors.grey:widget.postModel!.status==Status.inReview?Colors.red:Colors.green,),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text('${widget.postModel!.status}',style: GoogleFonts.poppins(fontSize:10 ),),
                      )),
                ),
              ],
            ),
            const Gap(6),


            GestureDetector(

                onTap: (){
                  showModalBottomSheet(context: context, builder: (context)=>Container(child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('${widget.postModel!.content}',style: GoogleFonts.poppins(fontSize: 16)),
                      ),
                      if(widget.postModel!.picture!.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.postModel!.picture!.length,
                              itemBuilder: (context,index)=>Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(imageUrl: widget.postModel!.picture![index],))),
                                  child: CachedNetworkImage(

                                    imageUrl: widget.postModel!.picture![index],
                                    //  width: 200,height: 100,
                                    fit: BoxFit.cover,),
                                ),
                              )),
                        ),
                      Gap(30),
                    ],
                  )));
                },
                child: Text('${widget.postModel!.content}',overflow: TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: 16),)),
            if(widget.postModel!.picture!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.postModel!.picture!.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(imageUrl: widget.postModel!.picture![index],))),

                        child: CachedNetworkImage(

                          imageUrl: widget.postModel!.picture![index],
                          //  width: 200,height: 100,
                          fit: BoxFit.contain,),
                      ),
                    )),
              ),

            Gap(20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: ()async{
                  // await  commentsController.getAllPostComments(postModel!.postId!);
                  showModalBottomSheet(context: context, builder: (_)=> StatefulBuilder(
                      builder: (context,widgets) {
                        return Column(
                          children: [

                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount :commentList.length,
                                  itemBuilder: (context,index)=>CommentsTile(comments:
                                  commentList[index],)),
                            ),
                            //const Spacer(),
                            commentsController.load?const Indicator2():    Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:commentsController.commentsCtrl,
                                        decoration: const InputDecoration(
                                          hintText: 'Type your message...',
                                        ),
                                        // Add any necessary logic or controllers for the TextField here
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: ()async {
                                        widgets((){

                                        });
                                        await  commentsController.createComment(widget.postModel!.postId!);
                                        // Add your send message logic here

                                        widgets((){

                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(20),
                          ],
                        );
                      }
                  ));
                },
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                 Image.asset('assets/comments.png',height: 15,width: 15,),
                    Gap(5),
                    Text( commentList.isEmpty?'':'${commentList.length} '),

                  ],
                ),
              ),
            )
          ],),
      ),
    );
  }
}




class CommentsTile extends ConsumerWidget {
  final Comments? comments;

  const CommentsTile({
    Key? key,this.comments
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 70,
        color: Colors.white,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius:15,child: Icon(Icons.person),),
                const Gap(10),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('${comments!.name}',style: GoogleFonts.poppins(fontSize:10,fontWeight:

                    FontWeight.bold),),
        Text(DateFormat('MMMM d, h:mm a').format(comments!.createdAt!),style: GoogleFonts.poppins(fontSize:7 ),),


                  ],
                ),
                const Spacer(),

              ],
            ),
            const Gap(6),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('${comments!.content}'),
            ),
            const Spacer(
            ),

          ],),
      ),
    );;
  }
}


class Status{
  static String resolved='resolved';
  static String pending='pending';
  static String inReview='In Review';
}