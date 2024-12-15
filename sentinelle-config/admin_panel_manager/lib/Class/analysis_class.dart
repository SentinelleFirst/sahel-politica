class Analysis {
  String id;
  String title;
  String titleFR;
  String subtitle;
  String subtitleFR;
  String resume;
  String resumeFR;
  List<Map<String, String>> preview;
  List<Map<String, String>> previewFR;
  String linkPDFEN;
  String linkPDFFR;
  String imageUrl;
  String category;
  String author;
  bool published;
  DateTime date;

  Analysis(
      this.id,
      this.title,
      this.titleFR,
      this.subtitle,
      this.subtitleFR,
      this.resume,
      this.resumeFR,
      this.preview,
      this.previewFR,
      this.linkPDFEN,
      this.linkPDFFR,
      this.imageUrl,
      this.category,
      this.author,
      this.published,
      this.date);

  factory Analysis.empty() {
    return Analysis(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      [],
      [],
      "",
      "",
      "",
      "",
      "",
      false,
      DateTime.now(),
    );
  }

  factory Analysis.copy(Analysis e) {
    return Analysis(
        e.id,
        e.title,
        e.titleFR,
        e.subtitle,
        e.subtitleFR,
        e.resume,
        e.resumeFR,
        e.preview,
        e.previewFR,
        e.linkPDFEN,
        e.linkPDFFR,
        e.imageUrl,
        e.category,
        e.author,
        e.published,
        e.date);
  }
}
