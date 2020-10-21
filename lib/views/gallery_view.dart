import 'dart:io';

import 'package:flutter/material.dart';
import 'package:martinsegagliotti/services/responsive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPage extends StatefulWidget {
  final List<dynamic> imageList;
  final Function fn;
  final bool isRascunho;
  const GalleryPage({Key key, this.imageList, this.fn, this.isRascunho = false})
      : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  int actualImageIndex = 0;

  List<Widget> imagesBottomCounter(int length) {
    List<Widget> display = [];
    for (var i = 0; i < length; i++) {
      if (i == actualImageIndex) {
        display.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            radius: Responsive.width(2),
            backgroundColor: Colors.blue,
          ),
        ));
      } else {
        display.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            radius: Responsive.width(2),
            backgroundColor: Colors.white,
          ),
        ));
      }
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Builder(
            builder: (_) {
              if (widget.fn != null &&
                  widget.imageList.length > 0 &&
                  !widget.isRascunho) {
                return IconButton(
                  onPressed: () {
                    if (!widget.isRascunho) {
                      setState(() {
                        if (actualImageIndex > 0) {
                          widget.imageList.removeAt(actualImageIndex--);
                        } else {
                          widget.imageList.removeAt(actualImageIndex);
                          if (widget.imageList.length == 0) {
                            Navigator.of(context).pop();
                          }
                        }
                        widget.fn();
                      });
                    }
                  },
                  iconSize: 26,
                  icon: Icon(Icons.delete_outline),
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      // Implemented with a PageView, simpler than setting it up yourself
      // You can either specify images directly or by using a builder as in this tutorial
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.imageList.length,
            onPageChanged: (index) {
              setState(() {
                actualImageIndex = index;
              });
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: (widget.fn == null)
                    ? NetworkImage(
                        widget.imageList[index],
                      )
                    : FileImage(
                        File(widget.imageList[index]),
                      ),
                // Contained = the smallest possible size to fit one dimension of the screen
                minScale: PhotoViewComputedScale.contained * 0.8,
                // Covered = the smallest possible size to fit the whole screen
                maxScale: PhotoViewComputedScale.covered * 2.5,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            // Set the background color to the "classic white"
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            loadingBuilder: (context, event) =>
                Center(child: CircularProgressIndicator()),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagesBottomCounter(widget.imageList.length),
              ),
            ),
          ),
          Builder(builder: (_) {
            if (widget.imageList.length == 0) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  'Nenhuma foto!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            } else {
              return SizedBox();
            }
          })
        ],
      ),
    );
  }
}
