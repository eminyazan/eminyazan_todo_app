import 'package:flutter/material.dart';

import '../consts/consts.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading...",style: boldTextStyleTitle(),),
            ),
            CircularProgressIndicator(color: Colors.orangeAccent,),
          ],
        ),
      ),
    );
  }
}

