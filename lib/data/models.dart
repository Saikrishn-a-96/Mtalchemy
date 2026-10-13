import 'package:flutter/material.dart';

class ServiceItem {
  final String title;
  final String summary;
  final String detail;
  final IconData icon;
  final Color accent;
  final String image;

  const ServiceItem({
    required this.title,
    required this.summary,
    required this.detail,
    required this.icon,
    required this.accent,
    required this.image,
  });
}

class Course {
  final String id;
  final String title;
  final String category;
  final String instructor;
  final String duration;
  final String level;
  final int modules;
  final double rating;
  final double price;
  final String image;
  final String blurb;
  final List<String> objectives;
  final List<String> curriculum;

  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.modules,
    required this.rating,
    required this.price,
    required this.image,
    required this.blurb,
    required this.objectives,
    required this.curriculum,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool isDigital;
  final String image;
  final String blurb;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.isDigital,
    required this.image,
    required this.blurb,
    this.stock = 40,
  });
}

class ImpactStory {
  final String title;
  final String clientType;
  final String programme;
  final int participants;
  final String objective;
  final String outcome;
  final String image;
  final List<String> tags;

  const ImpactStory({
    required this.title,
    required this.clientType,
    required this.programme,
    required this.participants,
    required this.objective,
    required this.outcome,
    required this.image,
    required this.tags,
  });
}

class Insight {
  final String title;
  final String category;
  final String readTime;
  final String image;

  const Insight({
    required this.title,
    required this.category,
    required this.readTime,
    required this.image,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class Employee {
  final String name;
  final String department;
  final String course;
  final int progress;
  final String status;

  const Employee({
    required this.name,
    required this.department,
    required this.course,
    required this.progress,
    required this.status,
  });
}

class CartLine {
  final Product product;
  int qty;

  CartLine(this.product, this.qty);
}
