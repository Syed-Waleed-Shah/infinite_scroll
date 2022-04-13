import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll.dart';

class ListExample extends StatefulWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  State<ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  Future<List<String>> getNextPageData(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    if (page == 3) return [];
    final items = List<String>.generate(14, (i) => "Item $i Page $page");
    return items;
  }

  List<String> data = [];
  bool everyThingLoaded = false;

  @override
  void initState() {
    super.initState();

    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔥 List Example')),
      body: InfiniteScrollList(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: data.map((e) => ListItem(text: e)).toList(),
        onLoadingStart: (page) async {
          List<String> newData = await getNextPageData(page);
          setState(() {
            data += newData;
            if (newData.isEmpty) {
              everyThingLoaded = true;
            }
          });
        },
        everythingLoaded: everyThingLoaded,
      ),
    );
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(0);
    setState(() {});
  }
}

class ListItem extends StatelessWidget {
  final String text;
  const ListItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.image),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
