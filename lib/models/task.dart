import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final List<String> tags;
  final int nbhours;
  final int difficulty;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.nbhours,
    required this.difficulty,
    required this.color,
  });

  /// Convertit un Task en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id == 0 ? null : id, // important pour AUTOINCREMENT
      'title': title,
      'description': description,
      'tags': tags.join(','), // stockage simple
      'nbhours': nbhours,
      'difficulty': difficulty,
      'color': color.value,
    };
  }

  /// Crée un Task depuis une Map SQLite
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      tags: map['tags'] != null && map['tags'] != ''
          ? (map['tags'] as String).split(',')
          : [],
      nbhours: map['nbhours'],
      difficulty: map['difficulty'],
      color: Color(map['color']),
    );
  }
}
