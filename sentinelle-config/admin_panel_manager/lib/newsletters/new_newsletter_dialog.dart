import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:admin_panel_manager/Class/article_class.dart';
import 'package:admin_panel_manager/Class/event_class.dart';
import 'package:admin_panel_manager/Class/newsletter_class.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class NewNewsletterDialog extends StatefulWidget {
  const NewNewsletterDialog(
      {super.key, required this.refresh, required this.contacts});

  final List<String> contacts;
  final Function() refresh;

  @override
  State<NewNewsletterDialog> createState() => _NewNewsletterDialogState();
}

class _NewNewsletterDialogState extends State<NewNewsletterDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late TextEditingController object;
  late TextEditingController message;
  late TextEditingController link;
  late TextEditingController linkText;
  List<Event> events = List<Event>.generate(
    3,
    (int index) => Event(
      "id $index",
      "Issaka Ouedraogo Speaks at WAMS Conference in Accra",
      "Issaka Ouedraogo s'exprime lors de la conférence de la WAMS à Accra",
      "WAMS Conference in Accra",
      "Conférence de la WAMS à Accra",
      "Ghana, Accra",
      "https://www.linkedin.com/posts/sahelpolitica_wams2023-miningsecurity-sahelpolitica-activity-7117773342169800704-ohaR",
      "reports/img/29-09-2023.jpg", // Chemin dans Firebase Storage
      "Conference",
      DateTime(2023, 09, 20),
      DateTime(2023, 09, 21),
    ),
    growable: true,
  );

  List<Article> articles = List<Article>.generate(
    5,
    (int index) => Article(
        "$index",
        "Burkina Faso's head of diplomacy in Doha to obtain humanitarian and security support from Qatar against jihadist groups.",
        "La cheffe de la diplomatie burkinabè à Doha pour obtenir des appuis humanitaires et sécuritaires du Qatar contre les groupes djihadistes.",
        "Burkina Faso requests humanitarian and security aid from Qatar",
        "Le Burkina Faso demande une aide humanitaire et sécuritaire au Qatar",
        "Olivia ROUAMBA, Minister of Foreign Affairs of Burkina Faso, stayed in Doha, Qatar from June 19 to 20, where she held talks with her Qatari counterpart, Sultan Bin Saad Al Muraikhi. During her stay, she advocated for security support from Qatar to her country to counter jihadist groups, including a recent attack on June 26, 2023, which left dozens of victims in the ranks of the army and its civilian auxiliaries. Burkina/Security: 40 terrorists neutralized and 31 soldiers and 3 VDP killed in an attack - leFaso.net  Minister Rouamba's visit to this very wealthy gas emirate illustrates the extension towards the Persian Gulf of the strategy driven by the rise to power of Captain Ibrahim Traoré to diversify Burkina Faso's security partnerships on the international stage. The transitional military authorities are thus emphasizing their desire to redirect the foreign policy of this country, previously supported by the Western bloc, particularly France, towards the Sino-Russian bloc.  The recent trip in May 2023 by Prime Minister Apollinaire de Tambela to Venezuela is another illustration of this. Upon his return, he stated in an interview with the Burkinabe media that he had been able to observe the political and economic engineering deployed by a country under international sanctions. This is an interesting observation, since the threat of additional ECOWAS sanctions against Burkina Faso remains current due to the lack of signals of political will from the military-dominated government to hold the elections normally scheduled for 2024. These three countries were suspended from the decision-making bodies of the West African organization after the coups that brought military leaders to power. In fact, the regional organization has decided to put the calendar of elections in Mali, Guinea and Burkina Faso back on the agenda of its summit on July 9. The acceleration of the Burkinabe authorities’ push to diversify economic and security partnerships could be motivated by the need to avoid diplomatic and economic isolation in the event of sanctions or a complete break with former Western support. Burkina has thus approached countries such as North Korea and Russia with a view to purchasing military equipment and materials against jihadist groups whose attacks are not decreasing.  These decisions are justified in Ouagadougou decision-making circles in particular by the following argument: The army needs weapons to counter the jihadists. However, acquisitions via traditional Western channels are slowed down or blocked by the states concerned, supposedly out of fear that their equipment will be used for possible human rights violations by Burkinabe security forces and civilian auxiliaries (VDP). It is true that the armed forces have recently been singled out by the media and ECOWAS for their possible involvement in the Karma massacre in April 2023. But the narrative promoted on the Ouagadougou side tends to present these considerations as the will of former partners who have been rejected, determined to punish the transitional authorities for their decision to move closer to countries perceived as strategic adversaries of the Western bloc.  Mali, now a key ally of the Burkinabe government with which it seems to share the same visions and discourses, is also trying to move closer to Qatar and other Gulf States in this perspective. As the Africa Intelligence newspaper points out, Qatar had already delivered around twenty Storm-type armoured vehicles to the Burkinabe authorities in 2019. If this partnership with Burkina and Mali were to deepen, it would be a boon for Qatari influence and interests, which seemed to have kept a low profile in the face of Turkey's muscular intrusion, thanks in particular to its military equipment manufacturer Baykar Technologies and its TB2 drones. On this subject, I recommend listening to the excellent podcast by our collaborator Gabriel Poda: 'The TB2 and Turkey's drone diplomacy' broadcast on the podcast Les Afriques En Question(s).",
        "Olivia ROUAMBA, ministre des affaires étrangères du Burkina Faso a séjourné à Doha au Qatar du 19 au 20 juin dernier où elle a eu des entretiens avec son homologue Qatari, Sultan Bin Saad Al Muraikhi. Au cours de son séjour, elle a plaidé pour un appui sécuritaire du Qatar à son pays pour contrer les groupes djihadistes dont une récente attaque, le 26 juin 2023, à fait plusieurs dizaines de victimes dans les rangs de l’armée et de ses auxiliaires civils. Burkina/Sécurité : 40 terroristes neutralisés et 31 militaires et 3 VDP tués dans une attaque - leFaso.net  La visite de la ministre Rouamba dans ce richissime émirat gazier illustre l’extension vers le Golfe Persique de la stratégie impulsée par l’arrivée au pouvoir du capitaine Ibrahim Traoré de diversifier les partenariats sécuritaires du Burkina Faso sur l’échiquier international. Les autorités militaires de transition accentuent ainsi leur volonté de réorienter vers le bloc Sino-Russe la politique étrangère de ce pays auparavant soutenu par le bloc occidental, notamment la France.   Le récent voyage en mai 2023 du Premier Ministre Apollinaire de Tambela au Venezuela en constitue une autre illustration. A son retour, il avait déclaré lors d’une interview accordée aux médias burkinabè qu’il avait pu observer l’ingénierie politique et économique déployée par un pays sous le coup de sanctions internationales. La remarque est intéressante, puisque la menace de sanctions additionnelle de la CEDEAO contre le Burkina reste actuelle en raison du manque de signaux de volonté politique du gouvernement à dominance militaire de tenir les élections prévues normalement en 2024. Ces trois pays ont été suspendus des organes décisionnels de l’organisation ouest-africaine après les coups d’Etat qui ont porté des militaires au pouvoir. Justement, l’organisation régionale a décidé de remettre au menu de son sommet le 9 juillet prochain, le calendrier des élections au Mali, en Guinée et au Burkina Faso.   L’accélération de la poussée de diversification des partenariats économiques et sécuritaires des autorités burkinabè pourrait être motivée par la nécessité d’éviter un isolement diplomatique et économique en cas de sanctions ou d’une rupture complète avec les anciens appuis occidentaux. Le Burkina a ainsi effectué des démarches auprès de pays comme la Corée du Nord et la Russie en vue d’acheter équipement et matériels militaires contre les groupes djihadistes dont les attaques ne baissent pas.   Ces décisions sont justifiées dans les cercles décisionnels ouagalais notamment par l’argument suivant : L’armée a besoin d’armes pour contrer les djihadistes. Or les acquisitions via les canaux occidentaux classiques sont ralenties ou bloquées par les Etats concernés, supposément par crainte que leurs équipements soient utilisés pour d’éventuelles violations des droits de l’Homme par les forces de sécurité et les auxiliaires civils burkinabè (VDP). Il est vrai que les forces armées ont récemment été indexées par les médias et la CEDEAO pour leur possible implication dans le massacre de Karma en avril 2023. Mais le narratif promu du côté de Ouagadougou tend à présenter ces considérations comme la volonté d’anciens partenaires éconduits, décidés à punir les autorités de transition pour leur décision de se rapprocher de pays perçus comme des adversaires stratégiques du bloc occidental.   Le Mali, désormais un allié clé du gouvernement burkinabè avec lequel il semble partager les mêmes visions et discours, tente aussi de se rapprocher du Qatar et d’autres États du Golfe dans cette perspective. Comme le rappelle le journal Africa Intelligence, le Qatar avait déjà livré une vingtaine de blindés de type Storm aux autorités burkinabè en 2019. Si ce partenariat avec le Burkina et le Mali devait s’approfondir, cela constituerait une aubaine pour l’influence et les intérêts qataris qui semblaient s’être faites discrètes face à l’entriste musclé de la Turquie grâce notamment à son équipementier militaire Baykar Technologies et ses drones TB2. Sur cette question, je recommande l’écoute de l’excellent podcast de notre collaborateur Gabriel Poda : « Le TB2 et la diplomatie du drone de la Turquie » diffusé sur le podcast Les Afriques En Question(s)",
        "https://www.linkedin.com/pulse/la-cheffe-de-diplomatie-burkinab%C3%A8-%C3%A0-doha-pour-obtenir-des/?trackingId=%2Bb%2BcAnFXhvQdyXnyVEb9qw%3D%3D",
        "https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/articles%2F1688121958343.jpeg?alt=media&token=c091bbdf-0c4a-4ff2-b1a6-d4db3c700d85",
        "Humanitarian and Security",
        "Issaka OUEDRAOGO",
        true,
        DateTime.now()),
    growable: true,
  );
  List<Analysis> analysis = List<Analysis>.generate(
    5,
    (int index) => Analysis(
        "$index",
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
    growable: true,
  );
  late Newsletter newsletterToModify;
  static String _displayStringForOption(String option) => option;
  static String _displayStringForEvent(Event option) => option.title;
  static String _displayStringForArticle(Article option) => option.title;
  static String _displayStringForAnalysis(Analysis option) => option.title;

  @override
  void initState() {
    super.initState();
    //Init Animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();

//On initalise un objet event sopiant les donner de l'event sélectionné.
    newsletterToModify = Newsletter.empty();

//On initialise des donnés à afficher
    object = TextEditingController();
    message = TextEditingController();
    link = TextEditingController();
    linkText = TextEditingController();

    if (newsletterToModify.contacts.length != widget.contacts.length) {
      choseAllContact = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void publishEvent() {}

  bool choseAllContact = true;
  int type = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.bottomRight,
      insetPadding: EdgeInsets.zero,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _offsetAnimation,
            child: child,
          );
        },
        child: Container(
          width: 600,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          height: MediaQuery.of(context).size.height,
          color: const Color(0xffF5F5F5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Edit newsletter",
                        style: secondTitleStyle,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          //Publier l'event
                          publishEvent();
                        });
                      },
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      minWidth: 100,
                      height: 50,
                      color: const Color(0xffFACB01),
                      child: Text(
                        "Send",
                        style: buttonTitleStyle,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                //Object info
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
                        "Object",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: object,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.object = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "...",
                              fillColor: const Color(0xFFECECEC),
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
                    ],
                  ),
                ),
                //Contact info
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contacts targets",
                            style: thirdTitleStyle,
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    choseAllContact = true;
                                  });
                                },
                                color: choseAllContact
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "ALL",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    choseAllContact = false;
                                  });
                                },
                                color: !choseAllContact
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "Select",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (!choseAllContact)
                        const SizedBox(
                          height: 20,
                        ),
                      if (!choseAllContact)
                        Column(
                          children: List.generate(
                            newsletterToModify.contacts.length,
                            (index) => ListTile(
                              title: Text(
                                newsletterToModify.contacts[index],
                                style: normalTextStyle,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      final value =
                                          newsletterToModify.contacts[index];
                                      newsletterToModify.contacts.remove(value);
                                    });
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xffECECEC),
                            borderRadius: BorderRadius.circular(5)),
                        child: choseAllContact
                            ? TextField(
                                enabled: false,
                                controller: TextEditingController(
                                    text:
                                        "All your ${widget.contacts.length} subscribers"),
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "...",
                                  fillColor: const Color(0xFFECECEC),
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
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                width: 300,
                                height: 55,
                                child: Autocomplete<String>(
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: SizedBox(
                                          width:
                                              300, // Contrôlez la largeur ici
                                          height:
                                              200, // Contrôlez la largeur ici
                                          child: ListView.builder(
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                    title: Text(option)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return widget.contacts
                                        .where((String option) {
                                      return option.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      if (!newsletterToModify.contacts
                                          .contains(selection)) {
                                        newsletterToModify.contacts
                                            .add(selection);
                                      }
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: '...',
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                //Type choice
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
                        "Type of annonce",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 1;
                                  });
                                },
                                color: type == 1
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New event",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 2;
                                  });
                                },
                                color: type == 2
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New article",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 3;
                                  });
                                },
                                color: type == 3
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New analysis",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 4;
                                  });
                                },
                                color: type == 4
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "Simple Message",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                //Select element
                if (type != 4)
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
                        if (type == 1)
                          Text(
                            "Select event",
                            style: thirdTitleStyle,
                          ),
                        if (type == 2)
                          Text(
                            "Select article",
                            style: thirdTitleStyle,
                          ),
                        if (type == 3)
                          Text(
                            "Select analysis",
                            style: thirdTitleStyle,
                          ),
                        Text(
                          "Title of the element select:",
                          style: normalTextStyle,
                        ),
                        Text(
                          newsletterToModify.elementTitle,
                          style: normalTextStyle,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: type == 1
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 300,
                                  height: 55,
                                  child: Autocomplete<Event>(
                                    displayStringForOption:
                                        _displayStringForEvent,
                                    optionsViewBuilder: (BuildContext context,
                                        AutocompleteOnSelected<Event>
                                            onSelected,
                                        Iterable<Event> options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: SizedBox(
                                            width:
                                                300, // Contrôlez la largeur ici
                                            height:
                                                200, // Contrôlez la largeur ici
                                            child: ListView.builder(
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final Event option =
                                                    options.elementAt(index);
                                                return GestureDetector(
                                                  onTap: () {
                                                    onSelected(option);
                                                  },
                                                  child: ListTile(
                                                      title:
                                                          Text(option.title)),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<Event>.empty();
                                      }
                                      return events.where((Event option) {
                                        return option.title.contains(
                                            textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (Event selection) {
                                      setState(() {
                                        newsletterToModify.imageUrl =
                                            selection.imageUrl;
                                        newsletterToModify.elementTitle =
                                            selection.title;
                                      });
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                            textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: const InputDecoration(
                                          labelText: '...',
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : type == 2
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 300,
                                      height: 55,
                                      child: Autocomplete<Article>(
                                        displayStringForOption:
                                            _displayStringForArticle,
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<Article>
                                                    onSelected,
                                                Iterable<Article> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: SizedBox(
                                                width:
                                                    300, // Contrôlez la largeur ici
                                                height:
                                                    200, // Contrôlez la largeur ici
                                                child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final Article option =
                                                        options
                                                            .elementAt(index);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                          title: Text(
                                                              option.title)),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                Article>.empty();
                                          }
                                          return articles
                                              .where((Article option) {
                                            return option.title.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (Article selection) {
                                          setState(() {
                                            newsletterToModify.imageUrl =
                                                selection.imageUrl;
                                            newsletterToModify.elementTitle =
                                                selection.title;
                                          });
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: const InputDecoration(
                                              labelText: '...',
                                              border: OutlineInputBorder(),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 300,
                                      height: 55,
                                      child: Autocomplete<Analysis>(
                                        displayStringForOption:
                                            _displayStringForAnalysis,
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<Analysis>
                                                    onSelected,
                                                Iterable<Analysis> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: SizedBox(
                                                width:
                                                    300, // Contrôlez la largeur ici
                                                height:
                                                    200, // Contrôlez la largeur ici
                                                child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final Analysis option =
                                                        options
                                                            .elementAt(index);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                          title: Text(
                                                              option.title)),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                Analysis>.empty();
                                          }
                                          return analysis
                                              .where((Analysis option) {
                                            return option.title.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (Analysis selection) {
                                          setState(() {
                                            newsletterToModify.imageUrl =
                                                selection.imageUrl;
                                            newsletterToModify.elementTitle =
                                                selection.title;
                                          });
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: const InputDecoration(
                                              labelText: '...',
                                              border: OutlineInputBorder(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                //link info
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
                        "Text for the annonce",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            controller: message,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.message = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "...",
                              fillColor: const Color(0xFFECECEC),
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
                    ],
                  ),
                ),
                //link info
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
                        "Link (optional)",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: linkText,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.linkText = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "See more by cliking here...",
                              fillColor: const Color(0xFFECECEC),
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
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: link,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.link = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "https://...",
                              fillColor: const Color(0xFFECECEC),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
