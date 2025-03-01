// import 'dart:html';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

//ignore: must_be_immutable
class SelectDropdownObj extends StatefulWidget {
  SelectDropdownObj({
    super.key,
    required this.width,
    required this.height,
    required this.options,
    required this.defaultValue,
    this.onChanged,
  });

  final double width;
  final double height;
  final List options;
  String defaultValue;
  final void Function(String?)? onChanged;

  @override
  State<SelectDropdownObj> createState() => _SelectDropdownObjState();
}

class _SelectDropdownObjState extends State<SelectDropdownObj> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
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
                      value: item['pk'].toString(),
                      child: Text(
                        item['name'],
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
                var option = value as String;
                widget.defaultValue = option;
                widget.onChanged!(option);
              });
            },
            iconStyleData: IconStyleData(
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 14,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.grey,
            ),
            buttonStyleData: ButtonStyleData(
              elevation: 2,
              height: 30,
              width: 150,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: const BoxDecoration(
                color: AppColors.third,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 8,
              // maxHeight: 30,
              padding: null,
              decoration: const BoxDecoration(
                color: AppColors.third,
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
              ),
            ),

            // scrollbarThickness: 6,
            // scrollbarAlwaysShow: true,
            // offset: const Offset(-20, 0),
          ),
        ),
      ),
    );
  }
}
