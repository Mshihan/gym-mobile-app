import 'package:flutter/material.dart';

class NewsBox extends StatefulWidget {
  NewsBox({
    required this.width,
    required this.height,
    required this.title,
    required this.by,
    required this.date,
    required this.paragraph,
    required this.url,
  });
  final double width;
  final double height;
  final String title;
  final String url;
  final String paragraph;
  final String by;
  final String date;

  @override
  _NewsBoxState createState() => _NewsBoxState();
}

class _NewsBoxState extends State<NewsBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.00),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: widget.width * 0.08,
      ),
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.width * 0.08,
            ),
            width: widget.width,
            padding: EdgeInsets.only(top: widget.height * 0.03),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //Image
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: widget.width * 0.07),
                width: widget.width,
                height: widget.height * 0.3,
                color: Colors.black38,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widget.width * 0.07),
                width: widget.width,
                height: widget.height * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    widget.url,
                  ),
                  fit: BoxFit.cover,
                )),
                // child: Image.network(
                //   widget.url,
                //   fit: BoxFit.cover,
                // ),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: widget.width * 0.07),
            child: Text(
              widget.paragraph,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.justify,
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: widget.width * 0.07),
                child: Text(
                  widget.by,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widget.width * 0.07),
                child: Text(
                  widget.date,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
