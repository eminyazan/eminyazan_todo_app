import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double height;
  final double width;
  final Widget? buttonIcon;
  final bool submited;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.buttonText,
    this.buttonColor: Colors.orange,
    this.textColor: Colors.white,
    this.radius: 15,
    this.height: 50,
    this.width: 200,
    required this.onPressed,
    this.buttonIcon,
    this.submited: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        child: submited==false?RaisedButton(
          onPressed: onPressed,
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              buttonIcon != null ? buttonIcon! : SizedBox(),
              Text(
                "   "+buttonText,
                style: TextStyle(color: textColor),
              ),
              Opacity(
                opacity: 0,
                child: buttonIcon,
              ),
            ],
          ),
        ):RaisedButton(
          onPressed: null,
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Center(child: CircularProgressIndicator(color: Colors.orangeAccent,),),
        ),
      ),
    );
  }
}
