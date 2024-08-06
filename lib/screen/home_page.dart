// home_page.dart
import 'package:edownloder/screen/download_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Downloader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                title: Text('YouTube'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadPage('YouTube')),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Facebook'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadPage('Facebook')),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Instagram'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadPage('Instagram')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}