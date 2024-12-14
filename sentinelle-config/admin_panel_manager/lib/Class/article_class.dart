class Article {
  String id;
  String title;
  String titleFR;
  String smallTitle;
  String smallTitleFR;
  String content;
  String contentFR;
  String linkedinPost;
  String imageUrl;
  String category;
  String author;
  bool published; //Que 2 status possible: soit publié, soit brouillons
  DateTime date;

  Article(
      this.id,
      this.title,
      this.titleFR,
      this.smallTitle,
      this.smallTitleFR,
      this.content,
      this.contentFR,
      this.linkedinPost,
      this.imageUrl,
      this.category,
      this.author,
      this.published,
      this.date);

  factory Article.empty() {
    return Article(
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
      "",
      false,
      DateTime.now(),
    );
  }

  factory Article.copy(Article e) {
    return Article(
      e.id,
      e.title,
      e.titleFR,
      e.smallTitle,
      e.smallTitleFR,
      e.content,
      e.contentFR,
      e.linkedinPost,
      e.imageUrl,
      e.category,
      e.author,
      e.published,
      e.date,
    );
  }
}
