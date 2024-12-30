import 'package:admin_panel_manager/Class/article_class.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../Class/profile_class.dart';
import '../constants.dart';
import '../login-manager/file_picker.dart';
import '../widgets/simple_page_title.dart';

class NewArticleView extends StatefulWidget {
  const NewArticleView(
      {super.key, required this.goBack, required this.currentProfile});
  final Function() goBack;
  final Profile currentProfile;

  @override
  State<NewArticleView> createState() => _NewArticleViewState();
}

class _NewArticleViewState extends State<NewArticleView> {
  Article articleToModify = Article.empty();
  late TextEditingController title;
  late TextEditingController titleFR;
  late TextEditingController smallTitle;
  late TextEditingController smallTitleFR;
  late TextEditingController content;
  late TextEditingController contentFR;
  late TextEditingController linkedinPost;
  late TextEditingController category;

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    titleFR = TextEditingController();
    smallTitle = TextEditingController();
    smallTitleFR = TextEditingController();
    content = TextEditingController();
    contentFR = TextEditingController();
    linkedinPost = TextEditingController();
    category = TextEditingController();
  }

  void saveModification() async {
    if (validateEntries()) {
      setState(() {
        saving = true;
      });
      await addArticle(articleToModify, context, () {
        setState(() {
          saving = false;
        });
      });
    }
  }

  void publishArticle() {
    if (validateEntries()) {
      setState(() {
        articleToModify.published = true;
      });

      saveModification();
    }
  }

  bool validateEntries() {
    if (articleToModify.title.isEmpty) {
      setState(() {
        showEnglishTitle = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title empty..."),
        ),
      );
      return false;
    } else if (articleToModify.titleFR.isEmpty) {
      setState(() {
        showEnglishTitle = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("French title empty..."),
        ),
      );
      return false;
    } else if (articleToModify.smallTitle.isEmpty) {
      setState(() {
        showEnglishSmallTitle = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Small title empty..."),
        ),
      );
      return false;
    } else if (articleToModify.smallTitleFR.isEmpty) {
      setState(() {
        showEnglishSmallTitle = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Small title in french empty..."),
        ),
      );
      return false;
    } else if (articleToModify.content.isEmpty) {
      setState(() {
        showEnglishContent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Content empty..."),
        ),
      );
      return false;
    } else if (articleToModify.contentFR.isEmpty) {
      setState(() {
        showEnglishContent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Content in french empty..."),
        ),
      );
      return false;
    } else if (articleToModify.category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category empty..."),
        ),
      );
      return false;
    } else if (articleToModify.linkedinPost.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Article link empty..."),
        ),
      );
      return false;
    } else if (articleToModify.imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Download an image..."),
        ),
      );
      return false;
    }
    return true;
  }

  bool saving = false;

  void downloadImage() async {
    setState(() {
      imgLoading = true;
    });
    await uploadImageToFirebase("articles", setUrlImg);
  }

  void setUrlImg(String url) {
    setState(() {
      articleToModify.imageUrl = url;
      imgLoading = false;
    });
  }

  bool imgLoading = false;

  bool showEnglishTitle = true;
  bool showEnglishSmallTitle = true;
  bool showEnglishContent = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: widget.goBack,
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 20,
                  ),
                  const SimplePageTitle(title: "New article"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (saving)
                    const CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  if (!saving)
                    MaterialButton(
                      onPressed: saveModification,
                      minWidth: 150,
                      height: 40,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.save,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Save modification",
                            style: buttonTitleStyle,
                          )
                        ],
                      ),
                    ),
                  if (!saving)
                    const SizedBox(
                      width: 20,
                    ),
                  if (!saving)
                    MaterialButton(
                      onPressed: gotAccesToArticlePublish(widget.currentProfile)
                          ? publishArticle
                          : null,
                      minWidth: 150,
                      height: 40,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.publish_rounded,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Save & Publish",
                            style: buttonTitleStyle,
                          )
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //Title info
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Title in ${showEnglishTitle ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishTitle = true;
                                            });
                                          },
                                          color: showEnglishTitle
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "EN",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishTitle = false;
                                            });
                                          },
                                          color: !showEnglishTitle
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "FR",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: showEnglishTitle
                                      ? TextField(
                                          controller: title,
                                          onChanged: (value) {
                                            setState(() {
                                              articleToModify.title = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "title...",
                                            fillColor: const Color(0xFFECECEC),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        )
                                      : TextField(
                                          controller: titleFR,
                                          onChanged: (value) {
                                            setState(() {
                                              articleToModify.titleFR = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "title...",
                                            fillColor: const Color(0xFFECECEC),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          //Short title info
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Short title in ${showEnglishSmallTitle ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishSmallTitle = true;
                                            });
                                          },
                                          color: showEnglishSmallTitle
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "EN",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishSmallTitle = false;
                                            });
                                          },
                                          color: !showEnglishSmallTitle
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "FR",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: showEnglishSmallTitle
                                      ? TextField(
                                          controller: smallTitle,
                                          onChanged: (value) {
                                            setState(() {
                                              articleToModify.smallTitle =
                                                  value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "small title...",
                                            fillColor: const Color(0xFFECECEC),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        )
                                      : TextField(
                                          controller: smallTitleFR,
                                          onChanged: (value) {
                                            setState(() {
                                              articleToModify.smallTitleFR =
                                                  value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "small title...",
                                            fillColor: const Color(0xFFECECEC),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          //Content
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Content in ${showEnglishContent ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishContent = true;
                                            });
                                          },
                                          color: showEnglishContent
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "EN",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishContent = false;
                                            });
                                          },
                                          color: !showEnglishContent
                                              ? const Color(0xffFACB01)
                                              : const Color(0xffECECEC),
                                          minWidth: 50,
                                          height: 50,
                                          child: Text(
                                            "FR",
                                            style: buttonTitleStyle,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffECECEC),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: showEnglishContent
                                          ? TextField(
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              controller: content,
                                              onChanged: (value) {
                                                setState(() {
                                                  articleToModify.content =
                                                      value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                hintText: "...",
                                                fillColor:
                                                    const Color(0xFFECECEC),
                                                border: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            )
                                          : TextField(
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              controller: contentFR,
                                              onChanged: (value) {
                                                setState(() {
                                                  articleToModify.contentFR =
                                                      value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                hintText: "...",
                                                fillColor:
                                                    const Color(0xFFECECEC),
                                                border: InputBorder.none,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //IMG box
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ImageNetwork(
                                    key: ValueKey(articleToModify.imageUrl),
                                    image: articleToModify.imageUrl,
                                    width: 540,
                                    height: 300,
                                    duration: 1500,
                                    curve: Curves.easeIn,
                                    debugPrint: false,
                                    fullScreen: false,
                                    fitAndroidIos: BoxFit.cover,
                                    fitWeb: BoxFitWeb.cover,
                                    onLoading: const CircularProgressIndicator(
                                      color: Color(0xffFACB01),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    imgLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.yellow,
                                          )
                                        : MaterialButton(
                                            onPressed: () {
                                              //Selection de l'image
                                              downloadImage();
                                            },
                                            color: Colors.white,
                                            shape: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            minWidth: 60,
                                            height: 60,
                                            child: const Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //Link info
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Article link",
                                  style: thirdTitleStyle,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffECECEC),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                      controller: linkedinPost,
                                      onChanged: (value) {
                                        setState(() {
                                          articleToModify.linkedinPost = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: "https://...",
                                        fillColor: const Color(0xFFECECEC),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          //Category info
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Category",
                                  style: thirdTitleStyle,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffECECEC),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                      controller: category,
                                      onChanged: (value) {
                                        setState(() {
                                          articleToModify.category = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: "category...",
                                        fillColor: const Color(0xFFECECEC),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
