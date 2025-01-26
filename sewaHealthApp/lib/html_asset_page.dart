
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mangalyan_web/services/utils.dart';

class HtmlAssetPage extends StatefulWidget {

  final String assetFile;
  final String title;
  const HtmlAssetPage(this.title, this.assetFile, {Key? key}) : super(key: key);

  @override
  State<HtmlAssetPage> createState() => _HtmlAssetPageState();
}

class _HtmlAssetPageState extends State<HtmlAssetPage> {
  String? htmlText;
  bool loaded = false;


  void _loadData() async {
    htmlText = await getFileData(widget.assetFile);
    setState(() {
      loaded = true;
      debugPrint("loaded: $htmlText");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build: loaded=$loaded");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loaded? Html( data: htmlText):Html(data:"""
                  <center>Please wait. Loading...</center>
                  """,
              ),
              const SizedBox(
                height: 64,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}