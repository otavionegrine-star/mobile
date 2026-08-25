class UserModel {
  String? id;
  String name;
  String email;

  // construtor
  UserModel({this.id, required this.name, required this.email});

  // ToMap
  Map<String, dynamic> toMap(){
    return {
      "id":id,
      "name":name,
      "email":email
    };
  }

  // FromMap => factory => construtor alternativo ao construtor principal
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map["id"].toString(),
    name: map["name"].toString(),
    email: map["email"].toString()
  );

  
}