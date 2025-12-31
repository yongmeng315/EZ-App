import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../utils/general_utils.dart';
import '../widgets/custom_tff.dart';

class ElecBillCalcul extends StatefulWidget {
  const ElecBillCalcul({super.key});

  @override
  State<ElecBillCalcul> createState() => _ElecBillCalculState();
}

class _ElecBillCalculState extends State<ElecBillCalcul> {
  late double height, width;
  final TextEditingController _previousMeterTEC = TextEditingController();
  final TextEditingController _currentMeterTEC = TextEditingController();
  double meterShouldBePaid = 0;
  double priceShouldBePaid = 0;

  double _rateBefore200 = 0.435;
  double _rateAfter200 = 0.509;

  void initializedState() {
    _previousMeterTEC.text = '0.00';
    _currentMeterTEC.text = '0.00';
  }

  @override
  void initState() {
    initializedState();
    super.initState();
  }

  double priceCalculationHelper() {
    meterShouldBePaid =
        double.parse(
          _currentMeterTEC.text.isEmpty ? '0.00' : _currentMeterTEC.text,
        ) -
        double.parse(
          _previousMeterTEC.text.isEmpty ? '0.00' : _previousMeterTEC.text,
        );

    double temp = 0;
    if (meterShouldBePaid > 200) {
      temp = 200 * _rateBefore200 + (meterShouldBePaid - 200) * _rateAfter200;
      return temp;
    }

    temp = meterShouldBePaid * _rateBefore200;
    return temp;
  }

  void priceCalculation(StateSetter setStateCal) {
    setStateCal(() {
      priceShouldBePaid = priceCalculationHelper();
    });
  }

  Widget meterShouldBePaidDesWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Meter should be paid (${_currentMeterTEC.text.isEmpty ? '0.00' : _currentMeterTEC.text} - ${_previousMeterTEC.text.isEmpty ? '0.00' : _previousMeterTEC.text}): ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        Text('${GeneralUtils.roundToTwo(meterShouldBePaid)}'),
      ],
    );
  }

  Widget priceShouldBePaidDesWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Price should be paid (${meterShouldBePaid > 200 ? '${200 * _rateBefore200} + ${GeneralUtils.roundToTwo((meterShouldBePaid - 200) * _rateAfter200)}' : '${GeneralUtils.roundToTwo(meterShouldBePaid * _rateBefore200)}'}): ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          '${NumberFormat.simpleCurrency(name: "MYR", decimalDigits: 2).format(priceShouldBePaid)}',
        ),
      ],
    );
  }

  List<Widget> meterCalculationDesWidget() {
    if (meterShouldBePaid > 200) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '200 * $_rateBefore200: ',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text('${GeneralUtils.roundToTwo(200 * _rateBefore200)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${GeneralUtils.roundToTwo(meterShouldBePaid - 200)} * $_rateAfter200: ',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              '${GeneralUtils.roundToTwo((meterShouldBePaid - 200) * _rateAfter200)}',
            ),
          ],
        ),
      ];
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${GeneralUtils.roundToTwo(meterShouldBePaid)} * $_rateBefore200: ',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            '${GeneralUtils.roundToTwo(meterShouldBePaid * _rateBefore200)}',
          ),
        ],
      ),
    ];
  }

  List<Widget> calculationDesWidget() {
    return [
      meterShouldBePaidDesWidget(),
      ...meterCalculationDesWidget(),
      priceShouldBePaidDesWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: (context, setStateCal) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Meter',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      height: 56,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                      ),
                      child: CustomTff(
                        controller: _currentMeterTEC,
                        textInputType: TextInputType.number,
                        onTap: () {
                          if (_currentMeterTEC.text == '0.00') {
                            _currentMeterTEC.text = '';
                            if (_previousMeterTEC.text.isEmpty) {
                              _previousMeterTEC.text = '0.00';
                              priceCalculation(setStateCal);
                            }
                            return;
                          }
                          if (_previousMeterTEC.text.isEmpty) {
                            _previousMeterTEC.text = '0.00';
                            priceCalculation(setStateCal);
                          }
                        },
                        // onTapUpOutside: (event) {
                        //   if (_currentMeterTEC.text.isEmpty) {
                        //     _currentMeterTEC.text = '0.00';
                        //   }
                        //
                        //   priceCalculation(setStateCal);
                        // },
                        onChanged: (newValue) {
                          if (newValue.isEmpty) {
                            _currentMeterTEC.text = '0.00';
                            priceCalculation(setStateCal);
                            _currentMeterTEC.text = '';
                            return;
                          }
                          if (newValue.length == 2 &&
                              newValue.startsWith('0') &&
                              !newValue.endsWith('.')) {
                            _currentMeterTEC.text = '0.${newValue[1]}';
                          }
                          if (_currentMeterTEC.text.isEmpty) {
                            _currentMeterTEC.text = '0.00';
                          }
                          if (_previousMeterTEC.text.isEmpty) {
                            _previousMeterTEC.text = '0.00';
                          }

                          priceCalculation(setStateCal);
                        },
                        onTapOutside: (event) {
                          if (_currentMeterTEC.text.isEmpty ||
                              double.parse(_currentMeterTEC.text) == 0) {
                            _currentMeterTEC.text = '0.00';
                          } else {
                            _currentMeterTEC.text = (double.parse(
                              _currentMeterTEC.text,
                            )).toStringAsFixed(2);
                          }

                          FocusScope.of(context).unfocus();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previous Meter',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      height: 56,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                      ),
                      child: CustomTff(
                        controller: _previousMeterTEC,
                        textInputType: TextInputType.number,
                        onTap: () {
                          if (_previousMeterTEC.text == '0.00') {
                            _previousMeterTEC.text = '';
                            if (_currentMeterTEC.text.isEmpty) {
                              _currentMeterTEC.text = '0.00';
                              priceCalculation(setStateCal);
                            }
                            return;
                          }
                          if (_currentMeterTEC.text.isEmpty) {
                            _currentMeterTEC.text = '0.00';
                            priceCalculation(setStateCal);
                          }
                        },
                        // onTapUpOutside: (event) {
                        //   if (_previousMeterTEC.text.isEmpty) {
                        //     _previousMeterTEC.text = '0.00';
                        //   }
                        //
                        //   priceCalculation(setStateCal);
                        // },
                        onChanged: (newValue) {
                          if (newValue.isEmpty) {
                            _previousMeterTEC.text = '0.00';
                            priceCalculation(setStateCal);
                            _previousMeterTEC.text = '';
                            return;
                          }

                          if (newValue.length == 2 &&
                              newValue.startsWith('0') &&
                              !newValue.endsWith('.')) {
                            _previousMeterTEC.text = '0.${newValue[1]}';
                          }

                          if (_currentMeterTEC.text.isEmpty) {
                            _currentMeterTEC.text = '0.00';
                          }
                          if (_previousMeterTEC.text.isEmpty) {
                            _previousMeterTEC.text = '0.00';
                          }

                          priceCalculation(setStateCal);
                        },
                        onTapOutside: (event) {
                          if (_previousMeterTEC.text.isEmpty ||
                              double.parse(_previousMeterTEC.text) == 0) {
                            _previousMeterTEC.text = '0.00';
                          } else {
                            _previousMeterTEC.text = (double.parse(
                              _previousMeterTEC.text,
                            )).toStringAsFixed(2);
                          }

                          FocusScope.of(context).unfocus();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            priceShouldBePaid < 0
                ? Text('Previous meter is less than current meter')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: calculationDesWidget(),
                  ),

            // TextButton(
            //   onPressed: () {
            //     priceCalculation(setStateCal);
            //   },
            //   child: Text('Calculate'),
            // ),
          ],
        );
      },
    );
  }
}
