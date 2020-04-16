import 'package:flutter/material.dart';
import 'package:restaurant_rlutter_ui/src/models/user.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final User user;
  ProfileAvatarWidget({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        
        Container(
          padding: const EdgeInsets.only(top:40),
          decoration: BoxDecoration(
            color: Color(0xFFea5c44),
            border: Border.all(width:0,color:Color(0xFFea5c44)),
          ),
          height: 180,
       
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          
              SizedBox(
                width: 130,
                height: 130,
                child: CircleAvatar(backgroundImage: NetworkImage(user.image.thumb)),
              ),
             
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: Color(0xFFea5c44),
           border: Border.all(width:0,color:Color(0xFFea5c44)),
           borderRadius: BorderRadius.only(
             bottomLeft: const Radius.circular(30.0),
               bottomRight: const Radius.circular(30.0)
           )
          ),
          child: Column(children: <Widget>[
            Text(
              user.name,
              style:TextStyle(fontSize:20,color:Colors.white),
            ),
            Text(
              user.address,
              // style: Theme.of(context).textTheme.caption,
              style:TextStyle(fontSize:12,color:Colors.white),
            ),

          ],),
        ),
       
      ],
    );
  }
}
