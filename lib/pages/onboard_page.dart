import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../consts/consts.dart';
import 'login/login_page.dart';


class OnBoardingPage extends StatefulWidget {
  final Box onBoardBox;
  const OnBoardingPage({Key? key, required this.onBoardBox}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

@override
  void initState() {
    super.initState();
    widget.onBoardBox.put("onBoardBox", true);
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage(),),);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset('assets/images/$assetName.svg', width: 350.0,height: 250,),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xFFFFDAB3),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "TODO App",
          body:"This app created by Muhammed Emin YAZAN for Squamobi.",
          image: _buildImage('developer'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "TODO App",
          body: "You can create your schedule day by day and hour by hour",
          image: _buildImage('create'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Easy Process",
          body:"You can create your account easily and safely.\n\nThat's all Lets Begin!",
          image: _buildImage('select'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      dotsContainerDecorator: BoxDecoration(color: Color(0xFFFFDAB3),),
      showSkipButton:true,
      skipFlex: 0,
      nextFlex: 0,
      skip:  Text("SKIP",style: boldTextStyleTitle(),),
      next:  Icon(Icons.arrow_forward,color: Colors.orangeAccent.shade700,size: 30,),
      done:  Text("Let's Begin",style: boldTextStyleTitle(),),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeColor: Colors.deepOrange,
        color: Colors.orangeAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}