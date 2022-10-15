import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClothesItem extends StatefulWidget {
  final String name;
  final String type;
  final String size;
  final List<String>? styles;
  final DocumentSnapshot documentSnapshot;
  
  const ClothesItem({
    required this.name,
    required this.documentSnapshot,
    required this.size,
    required this.type,
    this.styles,
  });

  @override
  _ClothesItemState createState() => _ClothesItemState();
}

class _ClothesItemState extends State<ClothesItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Rs. ${widget.size}",
                            style:
                            TextStyle(color: Colors.white, fontSize: 20)),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     IconButton(
                  //       onPressed: () {
                  //         editProduct(widget.isFavourite, widget.id);
                  //       },
                  //       icon: widget.isFavourite
                  //           ? Icon(
                  //         Icons.favorite,
                  //         color: Colors.greenAccent,
                  //       )
                  //           : Icon(
                  //         Icons.favorite_border,
                  //         color: Colors.greenAccent,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {
                  //         deleteProduct(widget.documentSnapshot);
                  //       },
                  //       icon: Icon(
                  //         Icons.delete,
                  //         color: Colors.redAccent,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
      ),
    );
  }
}