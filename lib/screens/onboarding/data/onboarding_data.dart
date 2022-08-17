import '../../../constants/app_images.dart';

class OnboardingModel {
  String title, subtitle, imageLink;
  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.imageLink,
  });
}

class OnboardingData {
  static List<OnboardingModel> boards = [
    OnboardingModel(
      title: 'Add your Products',
      subtitle:
          'A product is the item offered for sale. A product can be a service or an item. It can be physical or in virtual or cyber form',
      imageLink: AppImages.illustration1,
    ),
    OnboardingModel(
      title: 'Create orders',
      subtitle:
          'Payment is the transfer of money services in exchange product or Payments typically made terms agreed',
      imageLink: AppImages.illustration2,
    ),
    OnboardingModel(
      title: 'QR Code',
      subtitle: 'Track everything using QR codes.',
      imageLink: AppImages.illustration3,
    ),
  ];
}
