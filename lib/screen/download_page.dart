// download_page.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:edownloder/ad/ad_helper.dart';

class DownloadPage extends StatefulWidget {
  final String platform;

  const DownloadPage(this.platform, {super.key});

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  void _downloadVideo() async {
   
    if (_formKey.currentState!.validate()) {
      final url = _urlController.text;
      final dio = Dio();

      try {
        final response = await dio.get(url);
        final videoUrl = response.data['video_url'];

        if (videoUrl != null) {
          final file = await dio.download(videoUrl, './${DateTime.now().millisecondsSinceEpoch}.mp4');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video downloaded successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to download video')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download ${widget.platform} Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Enter video URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _downloadVideo,
              child: const Text('Download Video'),
            ),
            const SizedBox(height: 20),
            if (_bannerAd != null)
              SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}