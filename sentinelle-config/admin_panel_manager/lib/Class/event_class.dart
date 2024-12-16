class Event {
  late String id;
  late String title;
  late String titleFR;
  late String smallTitle;
  late String smallTitleFR;
  late String location;
  late String linkedinPost;
  late String imageUrl;
  late String category;
  late DateTime start;
  late DateTime end;

  Event(
      this.id,
      this.title,
      this.titleFR,
      this.smallTitle,
      this.smallTitleFR,
      this.location,
      this.linkedinPost,
      this.imageUrl,
      this.category,
      this.start,
      this.end);

  factory Event.empty() {
    return Event(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      DateTime.now(),
      DateTime.now(),
    );
  }

  factory Event.copy(Event e) {
    return Event(
      e.id,
      e.title,
      e.titleFR,
      e.smallTitle,
      e.smallTitleFR,
      e.location,
      e.linkedinPost,
      e.imageUrl,
      e.category,
      e.start,
      e.end,
    );
  }
}
