import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Utils {
  final _random = new Random();

  IconData randomIcon() {
    List possibleIcons = [
      Icons.circle,
      Icons.square_rounded,
      Icons.star_rate_rounded,
      CupertinoIcons.triangle_fill,
    ];

    IconData chosenIcon = possibleIcons[_random.nextInt(possibleIcons.length)];

    return chosenIcon;
  }

  Color randomColor() {
    List possibleColors = [
      Colors.blue,
      Colors.amber,
      Colors.green,
      Colors.red,
      Colors.deepOrange,
      Colors.purple,
      Colors.black,
    ];

    List colors = [...possibleColors];

    colors.shuffle(_random);

    return colors.first;
  }

  Widget displayImage(String imagePath){
    if(imagePath.startsWith('lib/assets/')){
      return Image.asset(
        imagePath,
      );
    }else{
      return Image.file(
        File(imagePath),
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    }
  }

}
