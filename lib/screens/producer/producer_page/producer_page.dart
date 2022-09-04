import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/profile/components/profile_picture_section.dart';

class ProducerPage extends StatefulWidget {
  const ProducerPage({Key? key}) : super(key: key);

  @override
  State<ProducerPage> createState() => _ProducerPageState();
}

class _ProducerPageState extends State<ProducerPage> {
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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePictureSection(size: size, self: false),
          ],
        ),
      ),
    );
  }
}
