import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../constants.dart';
import '../widgets/simple_page_title.dart';

class AnalysisEditView extends StatefulWidget {
  const AnalysisEditView(
      {super.key, required this.analysis, required this.goBack});

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
  }

  void saveModification() {}

  void publishAnalysis() {}

  bool showEnglishTitle = true;
  bool showEnglishSubtitle = true;
  bool showEnglishResume = true;
  bool showEnglishPreview = true;

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
                          "Save modifications",
                          style: buttonTitleStyle,
                        )
                      ],
                    ),
                  ),
                  if (!analysisToModify.published)
                    const SizedBox(
                      width: 20,
                    ),
                  if (!analysisToModify.published)
                    MaterialButton(
                      onPressed: publishAnalysis,
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
                            height: 500,
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
                                      "Resume in ${showEnglishPreview ? "English" : "French"}",
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
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffECECEC),
                                        borderRadius: BorderRadius.circular(5)),
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
                                    MaterialButton(
                                      onPressed: () {
                                        //Selection de l'image
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
