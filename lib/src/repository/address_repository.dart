// import 'dart:convert';
// import 'dart:io';

// import 'package:global_configuration/global_configuration.dart';
// import 'package:http/http.dart' as http;
// import 'package:restaurant_rlutter_ui/src/helpers/helper.dart';
// import 'package:restaurant_rlutter_ui/src/models/address.dart';
// import 'package:restaurant_rlutter_ui/src/models/user.dart';
// import 'package:restaurant_rlutter_ui/src/repository/user_repository.dart';



// Future<Stream<Address>> getAddress() async {
//   User _user = await getCurrentUser();
//   final String _apiToken = 'api_token=${_user.apiToken}&';
//   final String url =
//       '${GlobalConfiguration().getString('api_base_url')}address?$_apiToken"user_id"=${_user.id}';

//   final client = new http.Client();
//   final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

//   return streamedRest.stream
//       .transform(utf8.decoder)
//       .transform(json.decoder)
//       .map((data) => Helper.getData(data))
//       .map((data) => Address.fromJson(data));
// }

