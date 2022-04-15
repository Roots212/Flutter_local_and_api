class UserModal {
  String? user_id;
  String? first_name;
    String? last_name;

  String? email;
  String? password;

  UserModal(this.user_id, this.first_name,this.last_name,this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'first_name': first_name,
            'last_name': last_name,

      'email': email,
      'password': password
    };
    return map;
  }

  UserModal.fromMap(Map<String, dynamic> map) {
    user_id = map['user_id'];
    first_name = map['first_name'];
        last_name = map['last_name'];

    email = map['email'];
    password = map['password'];
  }
}