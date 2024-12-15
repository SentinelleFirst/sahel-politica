import 'package:admin_panel_manager/Class/article_class.dart';
import 'package:admin_panel_manager/articles/article_edit_view.dart';
import 'package:admin_panel_manager/articles/articles_list_view.dart';
import 'package:flutter/material.dart';

import 'new_article_view.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  @override
  void initState() {
    super.initState();
    showArticleViewList();
  }

  /// Permet de choisir troie option
  /// 1 pour l'ensemble des articles
  /// 2 pour un article à editer
  /// 3 pour un nouvel article
  ///
  void showNewArticleView() {
    setState(() {
      frameView = NewArticleView(
        goBack: showArticleViewList,
      );
    });
  }

  void showEditArticleView(Article article) {
    setState(() {
      frameView = ArticleEditView(
        article: article,
        goBack: showArticleViewList,
      );
    });
  }

  void showArticleViewList() {
    setState(() {
      frameView = ArticlesListView(
        editArticle: showEditArticleView,
        newArticle: showNewArticleView,
      );
    });
  }

  Widget frameView = ArticlesListView(
    editArticle: (Article a) {},
    newArticle: () {},
  );

  @override
  Widget build(BuildContext context) {
    return frameView;
  }
}
