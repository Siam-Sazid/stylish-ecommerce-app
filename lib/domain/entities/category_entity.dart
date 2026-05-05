import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String iconName;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
  });

  @override
  List<Object?> get props => [id];
}
