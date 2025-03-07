import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../components/network_image.dart';
import '../../../constants/app_defaults.dart';

class OnboardingContentView extends StatefulWidget {
  const OnboardingContentView({
    super.key,
    required this.board,
    required this.currentIndex,
    required this.onNext,
  });

  final Map<String, dynamic> board;
  final int currentIndex;
  final void Function() onNext;

  @override
  State<OnboardingContentView> createState() => _OnboardingContentViewState();
}

class _OnboardingContentViewState extends State<OnboardingContentView> {
  @override
  Widget build(BuildContext context) {
    var image = widget.board['onboarding_document'] != null
        ? '${dotenv.get('API')}/${widget.board['onboarding_document']['document']['path']}'
        : '${dotenv.get('S3')}/images/no-image.jpg';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(
              image,
              true,
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// Title, Subtitle, Button
        Padding(
          padding: const EdgeInsets.all(AppDefaults.padding * 2),
          child: Column(
            children: [
              Text(
                widget.board['title'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppDefaults.margin),
              Text(
                // widget.board['description'].length > 280
                //     ? widget.board['description'].substring(1, 280) + '...'
                //     : widget.board['description'],
                widget.board['description'],
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDefaults.margin),
              // Button
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Next'),
                  Row(
                    children: List.generate(
                      widget.currentIndex + 1,
                      (index) => Icon(
                        IconlyLight.arrowRight2,
                        color: widget.currentIndex == index
                            ? Colors.white
                            : Colors.white54,
                        size: 16,
                      ),
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
