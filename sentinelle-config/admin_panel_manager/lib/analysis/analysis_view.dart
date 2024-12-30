import 'package:flutter/material.dart';

import '../Class/analysis_class.dart';
import '../Class/profile_class.dart';
import 'analysis_edit_view.dart';
import 'analysis_list_view.dart';
import 'new_analysis_view.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key, required this.connectedProfil});

  final Profile connectedProfil;

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  void initState() {
    super.initState();
    /*showEditAnalysisView(
      Analysis(
          "1",
          "Burkina Faso - First anniversary of Ibrahim Traoré's accession to power",
          "Burkina Faso – Premier anniversaire de l’accession d’Ibrahim Traoré au pouvoir",
          "A break with France and a military alliance with Mali and Niger in an atmosphere of tension and intrigue within the regime.",
          "Rupture consommée avec la France et conclusion d’une alliance  militaire avec le Mali et le Niger dans une ambiance de tensions  et d’intrigues au sein du régime.",
          "A break with France and a military alliance with Mali and Niger in an atmosphere of tension and intrigue within the regime.",
          "Rupture consommée avec la France et conclusion d’une alliance militaire avec le Mali et le Niger dans une ambiance de tensions et d’intrigues au sein du régime.",
          [],
          [],
          "",
          "https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/reports%2Fpdf%2F18-09-23_FIRST-ANNIVERSARY-OF-IBRAHIM-TRAORE-ACCESSION-TO-POWER_FR.pdf?alt=media&token=102c396d-33ad-45c0-9f25-b61628ef583c",
          "https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/reports%2Fimg%2FIB.webp?alt=media&token=598e4704-d246-47a9-b107-c8ebfeec0a9f",
          "Sahel - Political transition",
          "Issaka OUEDRAOGO",
          true,
          DateTime.now()),
    );*/
    showAnalysisViewList();
  }

  void showNewAnalysisView() {
    setState(() {
      frameView = NewAnalysisView(
        currentProfile: widget.connectedProfil,
        goBack: showAnalysisViewList,
      );
    });
  }

  void showEditAnalysisView(Analysis analysis) {
    setState(() {
      frameView = AnalysisEditView(
        connectedProfil: widget.connectedProfil,
        analysis: analysis,
        goBack: showAnalysisViewList,
      );
    });
  }

  void showAnalysisViewList() {
    setState(() {
      frameView = AnalysisListView(
        connectedProfil: widget.connectedProfil,
        editAnalysis: showEditAnalysisView,
        newAnalysis: showNewAnalysisView,
      );
    });
  }

  Widget frameView = AnalysisListView(
    connectedProfil: Profile.empty(),
    editAnalysis: (Analysis a) {},
    newAnalysis: () {},
  );

  @override
  Widget build(BuildContext context) {
    return frameView;
  }
}
