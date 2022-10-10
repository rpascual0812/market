// import 'dart:html';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

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
    return SizedBox(
      width: 160,
      height: 55,
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    widget.defaultValue,
                    style: const TextStyle(
                      fontSize: AppDefaults.fontSize,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: widget.options
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: AppDefaults.fontSize,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: widget.defaultValue,
            onChanged: (value) {
              setState(() {
                widget.defaultValue = value as String;
              });
            },
            icon: const Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.grey,
            buttonHeight: 30,
            buttonWidth: 150,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: const BoxDecoration(
              color: AppColors.third,
            ),
            buttonElevation: 2,
            itemHeight: 30,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownWidth: 180,
            dropdownPadding: null,
            dropdownDecoration: const BoxDecoration(
              color: AppColors.third,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(-20, 0),
          ),
        ),
      ),
    );
  }
}
