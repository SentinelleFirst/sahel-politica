class Reservation {
  String id;
  String firstname;
  String lastname;
  String phone;
  String company;
  String email;
  String linkmeet;
  String location;
  String service;
  String message;
  Map answer;
  String statue;

  Reservation(
      this.id,
      this.firstname,
      this.lastname,
      this.phone,
      this.company,
      this.email,
      this.linkmeet,
      this.location,
      this.service,
      this.message,
      this.answer,
      this.statue);

  factory Reservation.empty() {
    return Reservation(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      {},
      "",
    );
  }

  factory Reservation.copy(Reservation r) {
    return Reservation(
        r.id,
        r.firstname,
        r.lastname,
        r.phone,
        r.company,
        r.email,
        r.linkmeet,
        r.location,
        r.service,
        r.message,
        r.answer,
        r.statue);
  }
}
