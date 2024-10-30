import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

class PlayerReadyMeScreen extends StatefulWidget {
  @override
  _PlayerReadyMeScreenState createState() => _PlayerReadyMeScreenState();
}

class _PlayerReadyMeScreenState extends State<PlayerReadyMeScreen> {
  // This method is used to load local HTML content
  Future<String> loadLocalHtml() async {
    return await rootBundle.loadString('assets/iframe.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Player Ready Me"),
          backgroundColor: Colors.blue,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: WebView(
          // Set initial URL to about:blank to avoid initial load
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            // Load the local HTML file into a string
            final String fileText = await loadLocalHtml();
            // Load the HTML content as a string into the WebView
            webViewController.loadHtmlString(fileText);
          },
        ));
  }
}
