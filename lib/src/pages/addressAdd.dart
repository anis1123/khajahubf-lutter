import 'dart:async';
import 'dart:convert';
// import 'dart:js';
import 'package:restaurant_rlutter_ui/config/app_config.dart' as config;
import 'package:restaurant_rlutter_ui/src/pages/order_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_rlutter_ui/generated/i18n.dart';
import 'package:restaurant_rlutter_ui/src/elements/CircularLoadingWidget.dart';
import 'package:restaurant_rlutter_ui/src/elements/PaymentMethodListItemWidget.dart';
import 'package:restaurant_rlutter_ui/src/elements/SearchBarWidget.dart';
import 'package:restaurant_rlutter_ui/src/elements/ShoppingCartButtonWidget.dart';
import 'package:restaurant_rlutter_ui/src/models/order.dart';
// import 'package:restaurant_rlutter_ui/src/models/address.dart';
import 'package:restaurant_rlutter_ui/src/models/payment_method.dart';
import 'package:restaurant_rlutter_ui/src/models/route_argument.dart';
import 'package:restaurant_rlutter_ui/src/repository/settings_repository.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:restaurant_rlutter_ui/src/models/user.dart';
import 'package:restaurant_rlutter_ui/src/models/address.dart';
import 'package:restaurant_rlutter_ui/src/repository/user_repository.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


const base = "https://eg.marjewellery.com/Multi/public/api/";
class API {
  static Future getUsers() async{
    
      User _user = await getCurrentUser();
      var url =base + 'address?api_token=${_user.apiToken}&user_id=${_user.id}';
        final response = await http.get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
          if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
            if (json.decode(response.body) != null) {
              return http.get(url);
            }
            
          }
  }
  static Future postAddress() async{
    
      User _user = await getCurrentUser();
      var url =base + 'address?api_token=${_user.apiToken}&user_id=${_user.id}';
        final response = await http.get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
          if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
            if (json.decode(response.body) != null) {
              return http.get(url);
            }
            
          }
  }
}

class Address {
   int id;
   String description;
   String address;
   String number;

  
  Address(int id, String description,String address, String number){
    this.id = id;
    this.description = description;
    this.address = address;
    this.number = number;
  }

  Address.fromJson(Map json)
      : id = json['id'],
        description= json['description'],
        address= json['address'],
        number= json['phone_number'];

  Map toJson() {
    return {'id': id, 'description': description, 'address': address,'phone_number':number};
  }
}
  var status ;

 registerData(String description ,String address , String number) async{
   User _user = await getCurrentUser();
    String myUrl = base + "storeaddress?api_token=${_user.apiToken}";
    String userId = _user.id;
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "user_id": "$userId",
          "description": "$description",
          "address" : "$address",
          "phone" : "$number" 
        } ) ;
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if(status){
      print('data : ${data["error"]}');
    }else{
      print('data : ${data["token"]}');
      // _save(data["token"]);
    }
}
  GlobalKey<ScaffoldState> scaffoldKey;
  addressDelete(String addressId) async{
    User _user = await getCurrentUser();
    String addressGet = addressId;   
    String myUrl = base + "deleteaddress/${addressGet}?api_token=${_user.apiToken}";
    final response = await  http.get(myUrl,
        headers: {
          'Accept':'application/json'
        },
    );
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("The Address was removed from your cart"),
    ));
    print(addressGet.toString());
  
  }


//  _save(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'token';
//     final value = token;
//     prefs.setString(key, value);
//   }

class AddressWidget extends StatefulWidget {
  RouteArgument routeArgument;

  AddressWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}



class _AddressWidgetState extends State<AddressWidget> {
  PaymentMethodList list;
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();


 final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  var users = new List<Address>();
  bool loading = true;
  getUsers() {
  API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => Address.fromJson(model)).toList();
        loading = false;
      });
    });
  }

  _submit(){
    loading = true;
    setState(() {
      Navigator.of(context).pop();
      if(_addressController.text.trim().isNotEmpty && 
        _descriptionController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty){
          registerData(_descriptionController.text.trim(),_addressController.text.trim(),_phoneController.text.trim())
          .whenComplete((){
            loading = false;
              RefreshIndicator(child: null, onRefresh: getUsers());
          });
       }
    });
  }


  deleteAddress(String addressId){
    print(addressId);
    setState(() {
      addressDelete(addressId);
    });
  }
 

  @override
  void initState() {
    list = new PaymentMethodList();
    if (!setting.payPalEnabled)
      list.paymentsList.removeWhere((element) {
        return element.name == "PayPal";
      });
    if (!setting.stripeEnabled)
      list.paymentsList.removeWhere((element) {
        return element.name == "Visa Card" || element.name == "MasterCard";
      });

     getUsers();

    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();

  }
  void dialog(){
      showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.only(bottom: 20,top:0,left:20,right:20),
                titlePadding: EdgeInsets.only(bottom: 20,top:33,left:20,right:20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    SizedBox(width: 10),
                    Text(
                      'Add Delivery Address',
                      style: Theme.of(context).textTheme.title,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                      
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          controller:_addressController,
                          decoration: new InputDecoration(
                          hintText: 'Tinkune, Kathmandu',
                          labelText: 'Full Address',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).focusColor),
                              ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
                                hasFloatingPlaceholder: true,
                                labelStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).hintColor),
                              ),
                            ),
                          
                          // validator: (input) => !input.contains('@') ? 'Not a valid email' : null,
                          // onSaved: (input) => widget.user.email = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          decoration:new InputDecoration(
                          hintText: '9860425223',
                          labelText: 'Mobile Number',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).focusColor),
                              ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
                                hasFloatingPlaceholder: true,
                                labelStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).hintColor),
                              ),
                        ),
                          
                          validator: (input) => input.trim().length < 3 ? 'Not a valid phone' : null,
                          // onSaved: (input) => widget.user.phone = input,
                        ),
                          new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          controller:_descriptionController,
                          decoration:new InputDecoration(
                          hintText: 'nearby',
                          labelText: 'Descriptions',
                          hintStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).focusColor),
                              ),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
                                hasFloatingPlaceholder: true,
                                labelStyle: Theme.of(context).textTheme.body1.merge(
                                TextStyle(color: Theme.of(context).hintColor),
                              ),
                        ),
                          
                          validator: (input) => input.trim().length < 3 ? 'Not a valid full Description' : null,
                          // onSaved: (input) => widget.user.name = input,
                        ),
                    
                    
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context,) {
    
    return Scaffold(     
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            dialog();
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Icon(Icons.add),
         
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Delivery Address',
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      // key: getUsers(),
      body:
      
     SingleChildScrollView(
       
        padding: EdgeInsets.only(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
          
            loading  ? SizedBox(
              height: 3,
              // padding: const EdgeInsets.symmetric(horizontal:0,vertical: 5), 
              child:LinearProgressIndicator(
                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.1),
                    ),
            ):
            // users.isEmpty ? 
            //   Text('No data')
            // :
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
              child: SearchBarWidget(),
            ),
              GestureDetector(
                onTap: (){
                  dialog();
                },
                 child:Padding(
                    padding: const EdgeInsets.only(bottom: 0,top:10, left: 20,right:20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                      leading: Icon(
                        Icons.map,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Delivery Addresses',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text('Select Your Preferred Drelivery Address'),
                    ),
                  )
                  ),  
          
            users.isEmpty ?
                Container(
          alignment: AlignmentDirectional.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Theme.of(context).focusColor.withOpacity(0.7),
                          Theme.of(context).focusColor.withOpacity(0.05),
                        ])),
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  'Don\'t have any address',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display2.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 50),
              !loading
                  ? FlatButton(
                      onPressed: () {
                        dialog();
                      },
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      color: Theme.of(context).accentColor.withOpacity(1),
                      shape: StadiumBorder(),
                      child: Text(
                        'Add Address',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          )  
            :
            GestureDetector( 
             child:ListView.separated(
               
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: users.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                // return PaymentMethodListItemWidget(paymentMethod: list.cashList.elementAt(index));
                  // return ListTile(title: Text(users[index].number));
                  var item = users[index];
                  return Dismissible(
                    key: ValueKey(item),
                    background: Container(
                      color:Colors.red,
                    ),
                     child: InkWell(
                        splashColor: Theme.of(context).accentColor,
                        focusColor: Theme.of(context).accentColor,
                        highlightColor: Theme.of(context).primaryColor,
                           onTap: () {
                            //  users.addOrder(users[index].id.toString());
                              // Navigator.of(context).pushNamed('/PaymentMethod', arguments:<String, String>{'id': users[index].id.toString()},);
                                saveAddress(users[index].id.toString());
                            },
                       child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                          ],
                        ),
                       
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.black45,
                                
                                ),
                              
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.all(Radius.circular(5)),
                              //   // image: Icon(Icons.map)
                                
                              // ),
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                            Text(
                                              users[index].address,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              maxLines: 3,
                                              style: Theme.of(context).textTheme.display1,
                                            ),
                                       
                                            Text(
                                              users[index].number,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.right,
                                              style: Theme.of(context).textTheme.caption,
                                            ),      
                                            Text(
                                              users[index].description,
                                              // paymentMethod.description,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                           
                                            Padding(padding: EdgeInsets.only(bottom:6),)
                                         
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                       ),
                  ),
                  onDismissed:(direction){     
                        setState(() {
                            deleteAddress(users[index].id.toString());
                            users.removeAt(index);
                                
                        });
                        
                  } ,
                  );
              }
            ),
            ),
          ],
          
        ),
        
      ),
      
    );
    
  }
  void saveAddress(String addressId){
    String addressGet = addressId;   
    saveAddressPreference(addressGet).then((bool committed) {
      Navigator.of(context).pushNamed('/PaymentMethod');
    });
  }
  
}
 // SharedPreferences

Future<bool> saveAddressPreference(String addressGet) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("addressPre", addressGet);
  return prefs.commit();
}


