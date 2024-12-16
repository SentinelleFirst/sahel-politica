class Newsletter {
  String id;
  String object;
  String message;
  String link;
  String linkText;
  String imageUrl;
  String elementTitle;
  List<String> contacts;
  String author;
  DateTime date;

  Newsletter(this.id, this.object, this.message, this.link, this.linkText,
      this.imageUrl, this.elementTitle, this.contacts, this.author, this.date);

  factory Newsletter.empty() {
    return Newsletter("", "", "", "", "", "", "", [], "", DateTime.now());
  }

  factory Newsletter.copy(Newsletter n) {
    return Newsletter(n.id, n.object, n.message, n.link, n.linkText, n.imageUrl,
        n.elementTitle, n.contacts, n.author, n.date);
  }
}
