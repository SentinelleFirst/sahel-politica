import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Class/profile_class.dart';
import '../constants.dart';
import '../widgets/simple_page_title.dart';
import 'delete_analysis_dialog.dart';

class AnalysisListView extends StatefulWidget {
  const AnalysisListView(
      {super.key,
      required this.editAnalysis,
      required this.newAnalysis,
      required this.connectedProfil});

  final Profile connectedProfil;
  final Function(Analysis) editAnalysis;
  final Function() newAnalysis;

  @override
  State<AnalysisListView> createState() => _AnalysisListViewState();
}

class _AnalysisListViewState extends State<AnalysisListView> {
  String search = "";
  List<Analysis> analysisList = [];

  @override
  void initState() {
    super.initState();
    //Récupération des messages
    getAllAnalysis();
  }

  Future<void> getAllAnalysis() async {
    List<Analysis> an = await fetchDBAnalysis();
    setState(() {
      an.sort(
        (a, b) => b.date.compareTo(a.date),
      );
      analysisList = an;
    });
  }

  List<Analysis> fetchAnalysis() {
    if (search.isEmpty) {
      return analysisList;
    } else {
      return analysisList.where((a) {
        return a.title.toLowerCase().contains(search.toLowerCase()) ||
            a.titleFR.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void openAnalysisDetail(Analysis analysis) {
    // Ajoutez une action pour ouvrir l'analyse
    widget.editAnalysis(analysis);
  }

  void deleteAnalysis(String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteAnalysisDialog(
        id: id,
        refresh: getAllAnalysis,
      ),
    );
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
              const SimplePageTitle(title: "In-dept analysis"),
              MaterialButton(
                onPressed: gotAccesToAnalysisCreate(widget.connectedProfil)
                    ? widget.newAnalysis
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
                      Icons.add_circle_outline_sharp,
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "New analysis",
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
                          "${fetchAnalysis().length} analysis",
                          style: secondTitleStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fetchAnalysis().length,
                      itemBuilder: (_, int index) {
                        return AnalysisInfoLine(
                          canDelete:
                              gotAccesToAnalysisDelete(widget.connectedProfil),
                          analysis: fetchAnalysis()[index],
                          delete: () {
                            deleteAnalysis(fetchAnalysis()[index].id);
                          },
                          readAction: () {
                            openAnalysisDetail(fetchAnalysis()[index]);
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

class AnalysisInfoLine extends StatelessWidget {
  const AnalysisInfoLine({
    super.key,
    required this.analysis,
    required this.readAction,
    required this.delete,
    required this.canDelete,
  });

  final Analysis analysis;
  final Function() readAction;
  final Function() delete;
  final bool canDelete;

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
                key: ValueKey(analysis.imageUrl),
                image: analysis.imageUrl,
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
                      analysis.title,
                      style: GoogleFonts.poppins(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      "Date : ${DateFormat.yMd().format(analysis.date)}\nAuthor : ${analysis.author}",
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 150,
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
                          onPressed: canDelete ? delete : null,
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.red,
                            size: 20,
                          )),
                    ],
                  ),
                  TextButton(
                      onPressed: () async {
                        if (analysis.linkPDFEN.isNotEmpty) {
                          final Uri url = Uri.parse(analysis.linkPDFEN);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "PDF - en",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.arrow_outward_rounded,
                              size: 25, color: Colors.black)
                        ],
                      )),
                  TextButton(
                      onPressed: () async {
                        if (analysis.linkPDFFR.isNotEmpty) {
                          final Uri url = Uri.parse(analysis.linkPDFFR);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "PDF - fr",
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.arrow_outward_rounded,
                              size: 25, color: Colors.black)
                        ],
                      )),
                  Text(
                    analysis.published ? "Published" : "Draft",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: analysis.published ? Colors.green : Colors.red),
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
