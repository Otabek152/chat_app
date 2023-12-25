class UserModel{
  const UserModel({required this.id,required this.name,required this.image , required this.username , required this.email});
  final String id;
  final String name;
  final String username;
  final String? image;
  final String email;
  factory UserModel.fromJson(Map<String , dynamic> json ){
    return UserModel(id: json['id'], name: json['name'], image: json['image'], username: json['username'] , email: json['email']);
  }
    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'email': email,
        'username' : username,
      };
}