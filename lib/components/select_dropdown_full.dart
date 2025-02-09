// import 'dart:html';
import 'package:flutter/material.dart';
import '../../constants/index.dart';

//ignore: must_be_immutable
class SelectDropdownFull extends StatefulWidget {
  SelectDropdownFull({
    super.key,
    required this.options,
    required this.defaultValue,
    this.onSelected,
  });

  final List<String> options;
  String defaultValue;
  final void Function()? onSelected;

  @override
  State<SelectDropdownFull> createState() => _SelectDropdownFullState();
}

class _SelectDropdownFullState extends State<SelectDropdownFull> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton(
          style: const TextStyle(color: Colors.black, fontSize: 18),
          value: widget.defaultValue,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Colors.black,
          ),
          underline: const SizedBox(),
          items: widget.options.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: const TextStyle(color: AppColors.secondary),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.defaultValue = newValue!;
            });
          },
          selectedItemBuilder: (BuildContext ctxt) {
            return widget.options.map<Widget>((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
