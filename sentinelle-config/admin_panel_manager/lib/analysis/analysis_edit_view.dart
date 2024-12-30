import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';

import '../Class/profile_class.dart';
import '../constants.dart';
import '../login-manager/file_picker.dart';
import '../widgets/simple_page_title.dart';

class AnalysisEditView extends StatefulWidget {
  const AnalysisEditView(
      {super.key,
      required this.analysis,
      required this.goBack,
      required this.connectedProfil});

  final Profile connectedProfil;
  final Analysis analysis;
  final Function() goBack;

  @override
  State<AnalysisEditView> createState() => _AnalysisEditViewState();
}

class _AnalysisEditViewState extends State<AnalysisEditView> {
  Analysis analysisToModify = Analysis.empty();
  late TextEditingController title;
  late TextEditingController titleFR;
  late TextEditingController subtitle;
  late TextEditingController subtitleFR;
  late TextEditingController resume;
  late TextEditingController resumeFR;
  late TextEditingController linkPDFEN;
  late TextEditingController linkPDFFR;
  late TextEditingController category;
  late TextEditingController preview;
  late TextEditingController previewFR;

  @override
  void initState() {
    super.initState();
    analysisToModify = Analysis.copy(widget.analysis);
    title = TextEditingController(text: widget.analysis.title);
    titleFR = TextEditingController(text: widget.analysis.titleFR);
    subtitle = TextEditingController(text: widget.analysis.subtitle);
    subtitleFR = TextEditingController(text: widget.analysis.subtitleFR);
    resume = TextEditingController(text: widget.analysis.resume);
    resumeFR = TextEditingController(text: widget.analysis.resumeFR);
    linkPDFEN = TextEditingController(text: widget.analysis.linkPDFEN);
    linkPDFFR = TextEditingController(text: widget.analysis.linkPDFFR);
    category = TextEditingController(text: widget.analysis.category);
    preview = TextEditingController();
    previewFR = TextEditingController();
  }

  void saveModification() async {
    if (validateEntries()) {
      setState(() {
        saving = true;
      });
      await updateDBAnalysis(analysisToModify, context, () {
        setState(() {
          saving = false;
        });
      });
    }
  }

  void publishAnalysis() {
    if (validateEntries()) {
      setState(() {
        analysisToModify.published = true;
      });

      saveModification();
    }
  }

  bool validateEntries() {
    if (analysisToModify.title.isEmpty) {
      setState(() {
        showEnglishTitle = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.titleFR.isEmpty) {
      setState(() {
        showEnglishTitle = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("French title empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.subtitle.isEmpty) {
      setState(() {
        showEnglishSubtitle = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subtitle empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.subtitleFR.isEmpty) {
      setState(() {
        showEnglishSubtitle = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subtitle in french empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.resume.isEmpty) {
      setState(() {
        showEnglishResume = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resume empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.resumeFR.isEmpty) {
      setState(() {
        showEnglishResume = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resume in french empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.preview.isEmpty) {
      setState(() {
        showEnglishPreview = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preview empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.previewFR.isEmpty) {
      setState(() {
        showEnglishPreview = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preview in french empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.linkPDFEN.isEmpty &&
        analysisToModify.linkPDFFR.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Article PDF empty..."),
        ),
      );
      return false;
    } else if (analysisToModify.imageUrl.isEmpty) {
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
    await uploadImageToFirebase("reports/img", setUrlImg);
  }

  void setUrlImg(String url) {
    setState(() {
      analysisToModify.imageUrl = url;
      imgLoading = false;
    });
  }

  bool imgLoading = false;

  bool showEnglishTitle = true;
  bool showEnglishSubtitle = true;
  bool showEnglishResume = true;
  bool showEnglishPreview = true;

  void selectPDFEN() async {
    await pdfPickerAndUpload("reports/pdf", setPDFENUrl);
  }

  void setPDFENUrl(String url) {
    setState(() {
      analysisToModify.linkPDFEN = url;
    });
  }

  void selectPDFFR() async {
    await pdfPickerAndUpload("reports/pdf", setPDFENUrl);
  }

  void setPDFFRUrl(String url) {
    setState(() {
      analysisToModify.linkPDFFR = url;
    });
  }

  String selectedPreviewEntrieType = "Title 1";

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
                  const SimplePageTitle(title: "Edit analysis"),
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
                      onPressed: gotAccesToAnalysisEdit(widget.connectedProfil)
                          ? saveModification
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
                            Icons.save,
                            size: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Save modifications",
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
                      onPressed:
                          gotAccesToAnalysisPublish(widget.connectedProfil)
                              ? publishAnalysis
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
                            "Publish",
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
                                              analysisToModify.title = value;
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
                                              analysisToModify.titleFR = value;
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
                                      "Subtitle in ${showEnglishSubtitle ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishSubtitle = true;
                                            });
                                          },
                                          color: showEnglishSubtitle
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
                                              showEnglishSubtitle = false;
                                            });
                                          },
                                          color: !showEnglishSubtitle
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
                                  child: showEnglishSubtitle
                                      ? TextField(
                                          controller: subtitle,
                                          onChanged: (value) {
                                            setState(() {
                                              analysisToModify.subtitle = value;
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
                                          controller: subtitleFR,
                                          onChanged: (value) {
                                            setState(() {
                                              analysisToModify.subtitleFR =
                                                  value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintText: "sous titre...",
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
                          //Resume
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
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
                                      "Resume in ${showEnglishResume ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishResume = true;
                                            });
                                          },
                                          color: showEnglishResume
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
                                              showEnglishResume = false;
                                            });
                                          },
                                          color: !showEnglishResume
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
                                      child: showEnglishResume
                                          ? TextField(
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              controller: resume,
                                              onChanged: (value) {
                                                setState(() {
                                                  analysisToModify.resume =
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
                                              controller: resumeFR,
                                              onChanged: (value) {
                                                setState(() {
                                                  analysisToModify.resumeFR =
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
                          //Preview
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
                                      "Preview in ${showEnglishPreview ? "English" : "French"}",
                                      style: thirdTitleStyle,
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              showEnglishPreview = true;
                                            });
                                          },
                                          color: showEnglishPreview
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
                                              showEnglishPreview = false;
                                            });
                                          },
                                          color: !showEnglishPreview
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
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffECECEC),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 55,
                                          width: 100,
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: selectedPreviewEntrieType,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedPreviewEntrieType =
                                                    newValue!;
                                              });
                                            },
                                            items: [
                                              "Title 1",
                                              "Title 2",
                                              "Paragraphe"
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:
                                                    Center(child: Text(value)),
                                              );
                                            }).toList(),
                                            icon: const SizedBox
                                                .shrink(), // Retirer l'icône
                                            underline: const SizedBox.shrink(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffECECEC),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: showEnglishPreview
                                                ? TextField(
                                                    expands: true,
                                                    minLines: null,
                                                    maxLines: null,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        preview.text = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      hintText: "rn...",
                                                      fillColor: const Color(
                                                          0xFFECECEC),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  )
                                                : TextField(
                                                    expands: true,
                                                    minLines: null,
                                                    maxLines: null,
                                                    textAlignVertical:
                                                        TextAlignVertical.top,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        previewFR.text = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      hintText: "fr...",
                                                      fillColor: const Color(
                                                          0xFFECECEC),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (showEnglishPreview &&
                                                    preview.text.isNotEmpty) {
                                                  if (selectedPreviewEntrieType ==
                                                      "Title 1") {
                                                    analysisToModify.preview
                                                        .add({
                                                      "h3": preview.text
                                                    });
                                                  } else if (selectedPreviewEntrieType ==
                                                      "Title 2") {
                                                    analysisToModify.preview
                                                        .add({
                                                      "h6": preview.text
                                                    });
                                                  } else if (selectedPreviewEntrieType ==
                                                      "Paragraphe") {
                                                    analysisToModify.preview
                                                        .add({
                                                      "p": preview.text
                                                    });
                                                  }
                                                } else if ((!showEnglishPreview) &&
                                                    previewFR.text.isNotEmpty) {
                                                  if (selectedPreviewEntrieType ==
                                                      "Title 1") {
                                                    analysisToModify.previewFR
                                                        .add({
                                                      "h3": previewFR.text
                                                    });
                                                  } else if (selectedPreviewEntrieType ==
                                                      "Title 2") {
                                                    analysisToModify.previewFR
                                                        .add({
                                                      "h6": previewFR.text
                                                    });
                                                  } else if (selectedPreviewEntrieType ==
                                                      "Paragraphe") {
                                                    analysisToModify.previewFR
                                                        .add({
                                                      "p": previewFR.text
                                                    });
                                                  }
                                                }
                                              });
                                            },
                                            icon: const Tooltip(
                                                message: "Add text",
                                                child: Icon(
                                                  Icons.arrow_downward_outlined,
                                                  size: 30,
                                                )))
                                      ],
                                    )),
                                if (showEnglishPreview)
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: List<Widget>.generate(
                                        analysisToModify.preview.length,
                                        (index) {
                                          String text = analysisToModify
                                              .preview[index]
                                              .entries
                                              .first
                                              .value;
                                          String balise = analysisToModify
                                              .preview[index].entries.first.key;
                                          return ListTile(
                                            title: Text(
                                              text,
                                              style: balise == "h3"
                                                  ? GoogleFonts.nunito(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : balise == "h6"
                                                      ? GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : GoogleFonts.nunito(
                                                          fontSize: 16),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    analysisToModify.preview
                                                        .removeAt(index);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                if (!showEnglishPreview)
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: List<Widget>.generate(
                                        analysisToModify.previewFR.length,
                                        (index) {
                                          String text = analysisToModify
                                              .previewFR[index]
                                              .entries
                                              .first
                                              .value;
                                          String balise = analysisToModify
                                              .previewFR[index]
                                              .entries
                                              .first
                                              .key;
                                          return ListTile(
                                            title: Text(
                                              text,
                                              style: balise == "h3"
                                                  ? GoogleFonts.nunito(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : balise == "h6"
                                                      ? GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : GoogleFonts.nunito(
                                                          fontSize: 16),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    analysisToModify.previewFR
                                                        .removeAt(index);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                )),
                                          );
                                        },
                                      ),
                                    ),
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
                                    key: ValueKey(analysisToModify.imageUrl),
                                    image: analysisToModify.imageUrl,
                                    width: 540,
                                    height: 300,
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
                                          analysisToModify.category = value;
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
                          //PDF picker
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
                                  "PDF",
                                  style: thirdTitleStyle,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: Text(
                                      "PDF file in english :",
                                      style:
                                          GoogleFonts.nunitoSans(fontSize: 20),
                                    ))),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          selectPDFEN();
                                        },
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffECECEC),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Text(
                                              analysisToModify.linkPDFEN,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: Text(
                                      "PDF file in english :",
                                      style:
                                          GoogleFonts.nunitoSans(fontSize: 20),
                                    ))),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          selectPDFFR();
                                        },
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xffECECEC),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Text(
                                              analysisToModify.linkPDFFR,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.nunitoSans(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
