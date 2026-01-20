import 'package:flutter/material.dart';

class ClientModel {

  final int? id;
  final String name;
  final int icon;
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
      'icon': icon,
      'iconColor': iconColor.toARGB32(),
    };
  }
factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      divida: map['divida'],
      icon: map['icon'],
      iconColor: Color(map['iconColor']),
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Cliente{id: $id, name: $name, icon: $icon, iconColor: $iconColor, divida: $divida}';
  }

  ClientModel copyWith({
    String? name,
    int? icon,
    Color? iconColor,
    double? divida
  }) {
    return ClientModel(
      divida: divida ?? this.divida,
       icon: icon ?? this.icon,
        iconColor: iconColor ?? this.iconColor,
         name: name ?? this.name);
  }

}