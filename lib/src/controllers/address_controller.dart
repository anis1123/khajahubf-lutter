// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:restaurant_rlutter_ui/src/models/address.dart';
// import 'package:restaurant_rlutter_ui/src/repository/address_repository.dart';

// class AddressController extends ControllerMVC {
//   Address address;
//   GlobalKey<ScaffoldState> scaffoldKey;

//   AddressController() {
//     this.scaffoldKey = new GlobalKey<ScaffoldState>();
//   }

//   void listenForFood({String message}) async {
//     final Stream<Address> stream = await getAddress();
//     stream.listen((Address _food) {
//       setState(() => address = _food);
//     }, onError: (a) {
//       print(a);
//       scaffoldKey.currentState?.showSnackBar(SnackBar(
//         content: Text('Verify your internet connection'),
//       ));
//     }, onDone: () {
  
//       if (message != null) {
//         scaffoldKey.currentState?.showSnackBar(SnackBar(
//           content: Text(message),
//         ));
//       }
//     });
//   }

// }
