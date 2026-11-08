import 'package:equatable/equatable.dart';

/// Data representation for an Onboarding screen item
class OnboardingModel extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.buttonText = 'Next',
  });

  @override
  List<Object?> get props => [title, description, imagePath, buttonText];
}
