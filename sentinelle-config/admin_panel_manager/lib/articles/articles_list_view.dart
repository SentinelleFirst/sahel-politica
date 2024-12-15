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
    article = List<Article>.generate(
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
