import 'package:flutter/material.dart';
import 'package:market/components/future_crops_page_tile.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';

import 'package:market/models/order.dart';

class FutureCropsPage extends StatefulWidget {
  const FutureCropsPage({Key? key}) : super(key: key);

  @override
  State<FutureCropsPage> createState() => _FutureCropsPageState();
}

class _FutureCropsPageState extends State<FutureCropsPage> {
  late List<Order> orders = [];
  bool isLoading = false;

  static const IconData leftArrow =
      IconData(0xe801, fontFamily: 'Custom', fontPackage: null);
  static const IconData rightArrow =
      IconData(0xe803, fontFamily: 'Custom', fontPackage: null);

  TextEditingController yearController = TextEditingController(text: '2022');

  final List<bool> _isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    refreshOrders();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();
    // yearController.dispose();
    super.dispose();
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  Widget getTabWidget(String title, double padding, bool isTabSelected) {
    return isTabSelected
        ? Text(title)
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.primary,
            child: Center(
                child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Use List View Here
        // Padding(ldOrders() => ListView(
        //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //   child: Material(
        //     color: Colors.white,
        //     borderRadius: AppDefaults.borderRadius,
        //     child: Container(
        //       width: MediaQuery.of(context).size.width,
        //       // padding: const EdgeInsets.all(AppDefaults.padding),
        //       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        //       child: const Center(
        //         child: Text('asdfadsf'),
        //       ),
        //     ),
        //   ),
        // ),

        Expanded(
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : orders.isNotEmpty
                    ? const Text(
                        'No data found',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )
                    : buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Material(
              color: Colors.white,
              borderRadius: AppDefaults.borderRadius,
              child: InkWell(
                onTap: () {},
                borderRadius: AppDefaults.borderRadius,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  // padding: const EdgeInsets.all(AppDefaults.padding),
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: IconButton(
                                          icon: const Icon(leftArrow),
                                          onPressed: () {
                                            yearController.text = (int.parse(
                                                        yearController.text) -
                                                    1)
                                                .toString();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white10,
                                          child: TextField(
                                            controller: yearController,
                                            autocorrect: true,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: IconButton(
                                          icon: const Icon(rightArrow),
                                          onPressed: () {
                                            yearController.text = (int.parse(
                                                        yearController.text) +
                                                    1)
                                                .toString();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: AppDefaults.margin),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[0] =
                                                    !_isSelected[0];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[0]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Jan',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[1] =
                                                    !_isSelected[1];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[1]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Feb',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[2] =
                                                    !_isSelected[2];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[2]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Mar',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[3] =
                                                    !_isSelected[3];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[3]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Apr',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[4] =
                                                    !_isSelected[4];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[4]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'May',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[5] =
                                                    !_isSelected[5];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[5]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Jun',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[6] =
                                                    !_isSelected[6];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[6]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Jul',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[7] =
                                                    !_isSelected[7];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[7]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Aug',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[8] =
                                                    !_isSelected[8];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[8]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Sep',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[9] =
                                                    !_isSelected[9];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[9]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Oct',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[10] =
                                                    !_isSelected[10];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[10]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Nov',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          height: 30,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isSelected[11] =
                                                    !_isSelected[11];
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _isSelected[11]
                                                  ? AppColors.secondary
                                                  : AppColors.primary,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'Dec',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          FutureCropsPageTile(
            pk: 1,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            location: 'Davao',
            productPhoto: 'https://i.imgur.com/zdLsFZ0.jpeg',
            onTap: () {},
          ),
          FutureCropsPageTile(
            pk: 2,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            location: 'Davao',
            productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            onTap: () {},
          ),
          FutureCropsPageTile(
            pk: 3,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            productPhoto: 'https://i.imgur.com/zdLsFZ0.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            pk: 4,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            pk: 5,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Almonds',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            productPhoto: 'https://i.imgur.com/zdLsFZ0.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
          FutureCropsPageTile(
            pk: 6,
            name: 'Juan Dela Cruz',
            profilePhoto: 'https://i.imgur.com/8G2bg5J.jpeg',
            product: 'Banana Supplier',
            quantity: '103 kg',
            date: 'April 2022',
            price: 'P 200 per kilo',
            productPhoto: 'https://i.imgur.com/R3Cpn1T.jpeg',
            location: 'Davao',
            onTap: () {},
          ),
        ],
      );
}
