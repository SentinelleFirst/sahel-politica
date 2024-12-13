class Message {
  String email;
  String fistname;
  String lastname;
  String company;
  String phone;
  String object;
  String message;
  String answer;
  DateTime date;
  bool readStatus;

  Message(this.email, this.fistname, this.lastname, this.company, this.phone,
      this.object, this.message, this.answer, this.date, this.readStatus);

  void markRead() {
    readStatus = true;
  }

  void markUnread() {
    readStatus = false;
  }

  String displayName() {
    return '$fistname $lastname';
  }
}
