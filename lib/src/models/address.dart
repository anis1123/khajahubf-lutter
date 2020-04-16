

class Address {
  // final String id;
  final String description;
  final String address;
  final String number;

  Address({this.description,this.address,this.number});

  factory Address.fromJson(Map<String, dynamic> json)
  {
      return new Address(
        // id: json['id'],
        description: json['description'],
        address: json['address'],
        number: json['phone_number'],
      );
  }
  // Address.fromJSON(Map<String, dynamic> jsonMap) {
  //   id = jsonMap['id'].toString();
  //   description = jsonMap['description'];
  //   address = jsonMap['address'];
  //   number = jsonMap['phone_number']; 
  // }

  // Map toMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"] = id;
  //   map["description"] = description;
  //   map["address"] = address;
  //   map["phone_number"] = number;
 
  //   return map;
  // }
}
