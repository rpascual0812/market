import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';

class ModeratorStartForm extends StatefulWidget {
  const ModeratorStartForm({
    Key? key,
    required this.userPk,
    required this.token,
    required this.callback,
  }) : super(key: key);

  final String userPk;
  final String token;
  final void Function(bool)? callback;

  @override
  State<ModeratorStartForm> createState() => _ModeratorStartFormState();
}

class _ModeratorStartFormState extends State<ModeratorStartForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    widget.callback!(true);
                  },
                  child: const Text('Start!'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
