import 'package:admin_panel_manager/widgets/simple_divider.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SimplePageTitle extends StatelessWidget {
  const SimplePageTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: pageTitleStyle,
        ),
        const SizedBox(
          width: 20,
        ),
        const SimpleDivider(
            width: 200, height: 6, color: Color(0xFFFACB01), borderRadius: 30)
      ],
    );
  }
}

class ComplexePageTitle extends StatefulWidget {
  const ComplexePageTitle(
      {super.key,
      required this.title,
      required this.searchFieldChange,
      required this.buttonAction,
      required this.buttonTitle});

  final String title;
  final Function(String) searchFieldChange;
  final Function() buttonAction;
  final String buttonTitle;

  @override
  State<ComplexePageTitle> createState() => _ComplexePageTitleState();
}

class _ComplexePageTitleState extends State<ComplexePageTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: pageTitleStyle,
            ),
            const SizedBox(
              width: 20,
            ),
            const SimpleDivider(
                width: 200,
                height: 6,
                color: Color(0xFFFACB01),
                borderRadius: 30)
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: widget.buttonAction,
              minWidth: 150,
              height: 40,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 2)),
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
                    widget.buttonTitle,
                    style: buttonTitleStyle,
                  )
                ],
              ),
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
                    widget.searchFieldChange(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xff929200),
                    ),
                    filled: true,
                    hintText: "Research...",
                    fillColor: Colors.white,
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
        ))
      ],
    );
  }
}
