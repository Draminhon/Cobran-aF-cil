import 'package:flutter/material.dart';

class ClientModel {

  final int? id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final double divida;

  ClientModel({
   this.id,
   required this.divida,
   required this.icon,
   required this.iconColor,
   required this.name,
  });

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'divida': divida,
      'icon': icon.codePoint,
      'iconColor': iconColor.toARGB32(),
    };
  }
factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      divida: map['divida'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      iconColor: Color(map['iconColor']),
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Cliente{id: $id, name: $name, icon: $icon, iconColor: $iconColor, divida: $divida}';
  }

}