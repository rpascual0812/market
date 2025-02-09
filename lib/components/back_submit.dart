import 'package:flutter/material.dart';
import '../constants/index.dart';

class BackSubmit extends StatelessWidget {
  const BackSubmit({
    super.key,
    this.submit,
    this.back,
  });

  final void Function()? submit;
  final void Function()? back;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: back,
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
          child: const Text(
            'Back',
            style: TextStyle(
              color: Colors.black54,
              fontSize: AppDefaults.fontSize + 1,
            ),
          ),
        ),
        TextButton(
          onPressed: submit,
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.black,
              fontSize: AppDefaults.fontSize + 1,
            ),
          ),
        ),
      ],
    );
  }
}
