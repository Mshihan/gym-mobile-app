import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.width,
    required this.height,
    required this.url,
    required this.title,
    required this.price,
    required this.category,
  });
  final double width;
  final double height;
  final String url;
  final String title;
  final String category;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          margin: EdgeInsets.only(
            right: width * 0.08,
            left: width * 0.08,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.00),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.04, horizontal: width * 0.1),
                    height: 200,
                    width: width,
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.04, horizontal: width * 0.1),
                    height: 200,
                    width: width,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                  left: width * 0.1,
                  right: width * 0.1,
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.1,
                    right: width * 0.1,
                    bottom: height * 0.03),
                child: Text(
                  double.parse(price).toStringAsFixed(2),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.03,
        ),
      ],
    );
  }
}
