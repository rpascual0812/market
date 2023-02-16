import 'package:flutter/material.dart';
import 'package:market/screens/profile/components/complaint_list.dart';

class Complaint extends StatefulWidget {
  const Complaint({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<StatefulWidget> createState() => ComplaintState();
}

class ComplaintState extends State<Complaint>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ComplaintList(token: widget.token);
  }
}
