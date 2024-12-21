import 'package:admin_panel_manager/Class/message_class.dart';
import 'package:admin_panel_manager/login-manager/send_email.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class MessageDetailsDialog extends StatefulWidget {
  const MessageDetailsDialog(
      {super.key, required this.message, required this.refresh});

  final Message message;
  final Function() refresh;

  @override
  State<MessageDetailsDialog> createState() => _MessageDetailsDialogState();
}

class _MessageDetailsDialogState extends State<MessageDetailsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late TextEditingController answerObject;
  late TextEditingController answerMessage;
  String emailObject = "";
  String emailContent = "";

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

//On initialise des donnés à afficher
    answerObject =
        TextEditingController(text: 'Reply to : ${widget.message.object}');
    answerMessage = TextEditingController();
    saveModification();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendEmail() {
    setState(() {
      saving = true;
    });
    if (validateEntries()) {
      saveModification();
      //Envoie email
      sendEmailCampaign(
          subject: answerObject.text,
          recipientEmails: [
            {"email": widget.message.company, "name": "Jane Doe"}
          ],
          content: answerMessage.text);
    }
  }

  void saveModification() async {
    await updateDBMessage(widget.message, () {
      widget.refresh();
    });
  }

  bool validateEntries() {
    if (emailObject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Object empty..."),
        ),
      );
      return false;
    } else if (emailContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Message empty..."),
        ),
      );
      return false;
    }
    return true;
  }

  bool answerView = false;
  bool saving = false;

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
                        answerView
                            ? "Your answer"
                            : "Message of the ${DateFormat.yMd().format(widget.message.date)}\nby ${widget.message.displayName()}",
                        style: secondTitleStyle,
                      ),
                    ),
                    if (saving)
                      const CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    if (answerView && !saving)
                      IconButton(
                          onPressed: () {
                            setState(() {
                              answerView = false;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 30,
                          )),
                    if (!saving)
                      MaterialButton(
                        onPressed: () {
                          if (answerView) {
                            setState(() {
                              //Send email
                              sendEmail();
                            });
                          } else {
                            setState(() {
                              answerView = true;
                            });
                          }
                        },
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        minWidth: 100,
                        height: 50,
                        color: const Color(0xffFACB01),
                        child: Text(
                          answerView ? "Send" : "Answer",
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

                //Email box
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
                        "Email",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            widget.message.email,
                            style: normalTextStyle,
                          )),
                    ],
                  ),
                ),
                //Company and phone box
                if (!answerView)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Company",
                                style: thirdTitleStyle,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.message.company,
                                    style: normalTextStyle,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Phone",
                                style: thirdTitleStyle,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.message.phone,
                                    style: normalTextStyle,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                //Object box
                if (!answerView)
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
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.message.object,
                              style: normalTextStyle,
                            )),
                      ],
                    ),
                  ),

                //Message box
                if (!answerView)
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
                          "Message",
                          style: thirdTitleStyle,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.message.message,
                              style: normalTextStyle,
                            )),
                      ],
                    ),
                  ),
                //Answer Object info
                if (answerView)
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
                          "Email object",
                          style: thirdTitleStyle,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              controller: answerObject,
                              onChanged: (value) {
                                setState(() {
                                  emailObject = value;
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
                //Answer message info
                if (answerView)
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
                        Text(
                          "Email content",
                          style: thirdTitleStyle,
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xffECECEC),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                controller: answerMessage,
                                onChanged: (value) {
                                  setState(() {
                                    emailContent = value;
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
                        ),
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
