import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_care/src/views/authentication/register.dart';

import '../../theme/app_theme.dart';
import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:AppTheme.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/logo.png',height: 200,width:
              200,),


          ),
          Text('Welcome to CCU Welfare Care',style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w700),),
          Gap(20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));

            }, child:Text('Sign in',style: GoogleFonts.poppins(color: AppTheme.primary,fontSize: 22,fontWeight: FontWeight.w700),),style: ElevatedButton.styleFrom(primary: AppTheme.white,minimumSize: Size(382,58),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: AppTheme.primary))), ),
          ),
Gap(20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Register()));
            }, child:Text('Register',style: GoogleFonts.poppins(color: AppTheme.white,fontSize: 22,fontWeight: FontWeight.w700),),style: ElevatedButton.styleFrom(primary: AppTheme.primary,minimumSize: Size(382,58),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), ),
          ),

        ],
      ),
    );
  }
}
