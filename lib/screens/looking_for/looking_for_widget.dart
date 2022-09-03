import 'package:flutter/material.dart';
import 'package:market/components/section_divider_title.dart';

import '../../constants/index.dart';
// import 'info_row.dart';

class LookingForWidget extends StatelessWidget {
  const LookingForWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white70,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              SectionDividerTitle(
                title: 'Looking For',
                onTap: () {},
              ),
              Container(
                margin: const EdgeInsets.all(0),
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Product',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Quantity',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Date',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('1', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Stephen', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Actor', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Actor', style: TextStyle(fontSize: 10))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5', style: TextStyle(fontSize: 10))),
                      DataCell(Text('John', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Student', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Student', style: TextStyle(fontSize: 10))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Harry', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Leader', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Leader', style: TextStyle(fontSize: 10))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15', style: TextStyle(fontSize: 10))),
                      DataCell(Text('Peter', style: TextStyle(fontSize: 10))),
                      DataCell(
                          Text('Scientist', style: TextStyle(fontSize: 10))),
                      DataCell(
                          Text('Scientist', style: TextStyle(fontSize: 10))),
                    ]),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
