class Profile {
  String id;
  String fistname;
  String lastname;
  String email;
  String post;
  Map access;
  DateTime dateOfCreation;

  Profile(this.id, this.fistname, this.lastname, this.email, this.post,
      this.access, this.dateOfCreation);

  String displayName() {
    return '$fistname $lastname';
  }
}
