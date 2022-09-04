// import 'dart:html';
import 'package:flutter/material.dart';
import '../../constants/index.dart';

//ignore: must_be_immutable
class SelectDropdown extends StatefulWidget {
  SelectDropdown({
    Key? key,
    required this.options,
    required this.defaultValue,
    this.onSelected,
  }) : super(key: key);

  final List<String> options;
  String defaultValue;
  final void Function()? onSelected;

  @override
  State<SelectDropdown> createState() => _SelectDropdownState();
}

class _SelectDropdownState extends State<SelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton(
          style: const TextStyle(color: Colors.white, fontSize: 10),
          value: widget.defaultValue,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 12,
            color: Colors.white,
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
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
