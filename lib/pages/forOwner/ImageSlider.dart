
import 'package:dots_indicator/dots_indicator.dart';
import 'package:findpg/config/ApiLinks.dart';
import 'package:findpg/pages/FullImageView.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final Map<String, dynamic> ownerData;
  bool asFinder;

  ImageSlider({required this.ownerData, required this.asFinder});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<dynamic>? imageUrlList;
  PageController _pageController = PageController(initialPage: 0);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    imageUrlList = widget.ownerData['ownerHostlePic'];
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  void updateImageUrlList() {
    imageUrlList = widget.ownerData['ownerHostlePic'];
  }

  @override
  void didUpdateWidget(covariant ImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerData != widget.ownerData) {
      updateImageUrlList();
      _pageController.jumpToPage(0); // Reset the page index to the first image
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  imageUrlList != null  ?
    Column(
      children: [
        Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrlList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final singleImageUrl =
                        '${ApiLinks.accessHostleImages}/${imageUrlList![index]}';
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImageView(
                                    imageUrl: imageUrlList![index],
                                    asFinder: widget.asFinder),
                              ),
                            );
                          },
                          child: Image.network(
                            singleImageUrl,
                            fit: BoxFit.fitHeight,
                          )),
                    );
                  },
                ),
              ),
        imageUrlList!.isNotEmpty
            ? DotsIndicator(
                dotsCount: imageUrlList!.length,
                position: _currentPage.toInt(),
                decorator: DotsDecorator(
                  activeColor: Colors.blue,
                  activeSize: const Size(10.0, 10.0),
                  spacing: EdgeInsets.all(4),
                ),
              )
            : Text('length 0'),
      ],
    ): Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(color: Colors.grey),
      child: Text('no image found'),
    );
  }
}
