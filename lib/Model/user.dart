class User{
  String? userid;
  String? firstName;
  String? lastName;
  String? email;
  String? city;

  User({this.userid, this.firstName, this.lastName, this.email, this.city});

  @override
  String toString() {
    return 'User{userid: $userid, firstName: $firstName, lastName: $lastName, email: $email, city: $city}';
  }
}