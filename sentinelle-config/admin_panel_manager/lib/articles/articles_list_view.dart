import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Class/article_class.dart';
import '../constants.dart';
import '../widgets/simple_page_title.dart';

class ArticlesListView extends StatefulWidget {
  const ArticlesListView(
      {super.key, required this.editArticle, required this.newArticle});

  final Function(Article) editArticle;
  final Function() newArticle;

  @override
  State<ArticlesListView> createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  String search = "";
  List<Article> article = [];

  @override
  void initState() {
    super.initState();
    //Récupération des messages
    getAllArticles();
  }

  Future<void> getAllArticles() async {
    List<Article> as = await fetchDBArticles();
    setState(() {
      article = as;
    });
  }

  List<Article> fetchArticles() {
    if (search.isEmpty) {
      return article;
    } else {
      return article.where((a) {
        return a.title.toLowerCase().contains(search.toLowerCase()) ||
            a.titleFR.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void openArticleDetail(Article article) {
    // Ajoutez une action pour ouvrir l'événement
    widget.editArticle(article);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SimplePageTitle(title: "Articles"),
              MaterialButton(
                onPressed: widget.newArticle,
                minWidth: 150,
                height: 40,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline_sharp,
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "New article",
                      style: buttonTitleStyle,
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(24, 0, 0, 0), width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 500,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  search = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff929200),
                                ),
                                filled: true,
                                hintText: "Research...",
                                fillColor: const Color(0xffECECEC),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )),
                        Text(
                          "${fetchArticles().length} articles",
                          style: secondTitleStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fetchArticles().length,
                      itemBuilder: (_, int index) {
                        return ArticleInfoLine(
                          article: fetchArticles()[index],
                          readAction: () {
                            openArticleDetail(fetchArticles()[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleInfoLine extends StatelessWidget {
  const ArticleInfoLine({
    super.key,
    required this.article,
    required this.readAction,
  });

  final Article article;
  final Function() readAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(24, 0, 0, 0), width: 2),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ImageNetwork(
                image: article.imageUrl,
                width: 300,
                height: 170,
                duration: 1500,
                curve: Curves.easeIn,
                onPointer: true,
                debugPrint: false,
                fullScreen: false,
                fitAndroidIos: BoxFit.cover,
                fitWeb: BoxFitWeb.cover,
                onLoading: const CircularProgressIndicator(
                  color: Color(0xffFACB01),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: GoogleFonts.poppins(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      "Date : ${DateFormat.yMd().format(article.date)}\nAuthor : ${article.author}",
                      style: GoogleFonts.poppins(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: readAction,
                          icon: const Icon(
                            Icons.edit_note_rounded,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () async {
                            if (article.linkedinPost.isNotEmpty) {
                              final Uri url = Uri.parse(article.linkedinPost);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                            size: 20,
                          )),
                    ],
                  ),
                  Text(
                    article.published ? "Published" : "Draft",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: article.published ? Colors.green : Colors.red),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
