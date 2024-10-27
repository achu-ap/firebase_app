class Usermodel {
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String phonenumber;
  final String userid;
  Usermodel({
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.userid
  });
  toJSON() {
    return {
      "userid": userid,
      "username": username,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "phone number": phonenumber.toString(),
    };
  }
}
