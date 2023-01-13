import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/components/appbar.dart';
import 'package:http/http.dart' as http;

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

  Future findUser() async {
    try {
      final params = {'type': 'support'};
      final url = Uri.parse('${dotenv.get('API')}/chats/user/${widget.userPk}')
          .replace(queryParameters: params);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          widget.callback!(true);
        });
      }
      return null;
    } on Exception catch (e) {
      print('ERROR $e');
      return null;
    }
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
                    findUser();
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
