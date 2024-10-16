import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageSlider extends StatefulWidget {
  late List<String> images;
  late List<String> imagesSemantics;

  ImageSlider({required this.images, required this.imagesSemantics});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentImageIndex = 0;
  int _ImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_ImageIndex > widget.images.length) {
      _ImageIndex = 0;
    }
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: false,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 1.0,
            onPageChanged: (index, _) {
              setState(() {
                _currentImageIndex = index;
                _ImageIndex = index;
              });
            },
          ),
          items: widget.images.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Semantics(
                  label: widget.imagesSemantics[_ImageIndex],
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(8.0), // Add rounded corners here
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Clip the image to rounded corners
                      child: Image.network(
                        item,
                        fit: BoxFit.fitHeight,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // Return the default image when an error occurs
                          return Image.asset(
                            'assets/maxresdefault.jpg', // Provide the path to your default image here
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((url) {
            int index = widget.images.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == index
                    ? Color(0xffB2EFE4)
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
