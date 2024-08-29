import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  final List<dynamic> photoUrls;

  const CustomPageView({super.key, required this.photoUrls});

  @override
  _CustomPageViewState createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
                // ClipRRect를 사용하여 이미지를 둥글게 잘라냅니다.
                borderRadius: BorderRadius.circular(15),
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: widget.photoUrls.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.photoUrls[index],
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.fitWidth,
                    );
                  },
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(500)),
              child: Text(
                '${_currentPage + 1} / ${widget.photoUrls.length}', // 현재 페이지 / 전체 페이지
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}
