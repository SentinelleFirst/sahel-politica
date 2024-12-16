import 'package:admin_panel_manager/constants.dart';
import 'package:admin_panel_manager/messages/message_details_dialog.dart';
import 'package:admin_panel_manager/widgets/simple_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Class/message_class.dart';
import '../widgets/simple_page_title.dart';
import 'package:intl/intl.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  String search = "";
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    //Récupération des messages
    getAllMessages();
  }

  Future<void> getAllMessages() async {
    List<Message> an = await fetchDBMessages();
    setState(() {
      messages = an;
    });
  }

  List<Message> fetchMessages() {
    if (search.isEmpty) {
      return messages;
    } else {
      return messages.where((m) {
        return m.displayName().toLowerCase().contains(search.toLowerCase()) ||
            m.email.toLowerCase().contains(search.toLowerCase()) ||
            m.object.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void setSearchValue(String value) {
    setState(() {
      search = value;
    });
  }

  void openMessage(Message message) {
    // Ajoutez une action pour ouvrir l'événement
    setState(() {
      messages.firstWhere((m) => m.id == message.id).markRead();
    });
    showDialog(
      context: context,
      builder: (context) =>
          MessageDetailsDialog(message: message, refresh: () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Messages"),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latest messages",
                          style: secondTitleStyle,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 300,
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fetchMessages().length,
                      itemBuilder: (_, int index) {
                        return MessageInfoLine(
                          message: fetchMessages()[index],
                          readAction: () {
                            openMessage(fetchMessages()[index]);
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

class MessageInfoLine extends StatefulWidget {
  const MessageInfoLine({
    super.key,
    required this.message,
    required this.readAction,
  });

  final Message message;
  final Function() readAction;

  @override
  State<MessageInfoLine> createState() => _MessageInfoLineState();
}

class _MessageInfoLineState extends State<MessageInfoLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.3)))),
      child: ListTile(
        onTap: widget.readAction,
        leading: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: widget.message.readStatus
                  ? Colors.white
                  : const Color(0xffFACB01),
              borderRadius: BorderRadius.circular(5)),
        ),
        title: Row(
          children: [
            SizedBox(
                width: 130,
                child: Text(
                  widget.message.displayName(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight:
                          !widget.message.readStatus ? FontWeight.bold : null),
                )),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Text(
                widget.message.object,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight:
                        !widget.message.readStatus ? FontWeight.bold : null),
              ),
            ),
            const SimpleDivider(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 10,
                height: 1,
                color: Colors.black,
                borderRadius: 0),
            Expanded(
              flex: 2,
              child: Text(
                widget.message.message,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          DateFormat.yMMMd().format(widget.message.date),
          style: GoogleFonts.nunitoSans(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
