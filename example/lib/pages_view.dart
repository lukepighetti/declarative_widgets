import 'package:declarative_widgets/declarative_page_view.dart';
import 'package:flutter/material.dart';

class PagesView extends StatefulWidget {
  const PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  var page = DpvPage.one;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          SafeArea(
            minimum: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => page = DpvPage.one),
                ),
                Text(page.name),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => page = DpvPage.two),
                ),
              ],
            ),
          ),
          Expanded(
            child: DeclarativePageView(
              value: page,
              onChange: (x) => setState(() => page = x),
              pages: DpvPage.values,
              physics: const NeverScrollableScrollPhysics(),
              builder: (context, value) {
                return switch (value) {
                  DpvPage.one => Center(
                      child: Text(value.name),
                    ),
                  DpvPage.two => Center(
                      child: Text(value.name),
                    ),
                  DpvPage.three => Center(
                      child: Text(value.name),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum DpvPage {
  one,
  two,
  three,
}
