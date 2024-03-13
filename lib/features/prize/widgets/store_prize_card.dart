import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/prize/controller/prize_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StorePrizeCard extends ConsumerStatefulWidget {
  final String title;
  final String prizeDeactivated;
  final String prizeActivated;
  final int prizePrice;
  final AsyncValue<void> state;

  const StorePrizeCard({super.key, required this.title, required this.prizeDeactivated, required this.prizeActivated, required this.prizePrice, required this.state});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StorePrizeCardState();
}

class _StorePrizeCardState extends ConsumerState<StorePrizeCard> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(20.0), color: Colors.black),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: PageView(
                    controller: _controller,
                    children: [
                      Image.network(widget.prizeActivated),
                      Image.network(widget.prizeDeactivated),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SmoothPageIndicator(
                          controller: _controller,
                          count: 2,
                          effect: JumpingDotEffect(activeDotColor: theme.colorScheme.secondary, dotWidth: 10, dotHeight: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
      Container(),
      FilledButton.icon(
        onPressed: () => _orderBottomSheet(context, widget.state, widget.title, widget.prizePrice),
        icon: const Icon(Icons.monetization_on),
        label: Text(widget.prizePrice.toString()),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(170, 30)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5)),
        ),
      ),
    ]);
  }

  _orderBottomSheet(BuildContext context, state, String prizeType, int price) {
    final ThemeData theme = Theme.of(context);
    final GlobalKey<FormState> buyFormKey = GlobalKey();
    final quantity = ref.watch(quantityProvider);
    int totalPrice = price * quantity;
    final user = ref.watch(accountProvider)!;
    final int lizzyCoins = user.lizzyCoins;

    return CustomBottomSheet.show(
      context: context,
      listWidget: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: buyFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(LocaleKeys.completePurchase.tr(), style: theme.textTheme.titleMedium),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: PageView(
                                controller: _controller,
                                children: [
                                  Image.network(widget.prizeActivated),
                                  Image.network(widget.prizeDeactivated),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SmoothPageIndicator(
                                      controller: _controller,
                                      count: 2,
                                      effect: JumpingDotEffect(
                                        activeDotColor: theme.colorScheme.secondary,
                                        dotWidth: 10,
                                        dotHeight: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                    Text(prizeType, style: theme.textTheme.titleMedium),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                      textInputType: TextInputType.number,
                      labelText: LocaleKeys.quantity.tr(),
                      initialValue: quantity.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: emptyField,
                      onChanged: (value) {
                        int parsedValue = parseStringToInt(value);
                        ref.read(quantityProvider.notifier).state = parsedValue;

                        setState(() {
                          totalPrice = ref.watch(totalPriceProvider(price));
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      LocaleKeys.totalPay.tr(namedArgs: {"totalPrice": totalPrice.toString()}),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (buyFormKey.currentState!.validate() && totalPrice != 0) {
                          if (totalPrice <= lizzyCoins) {
                            ref.read(prizeControllerProvider.notifier).buyPrize(widget.title, quantity, widget.prizePrice).then(
                                  (value) => showSnackBar(LocaleKeys.purchaseCompleted.tr(), context),
                                );
                          } else {
                            showSnackBar(LocaleKeys.notEnoughCoins.tr(), context);
                          }
                        } else {
                          showSnackBar(LocaleKeys.selectQuantity.tr(), context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            color: theme.colorScheme.secondary),
                        child: state.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : Text(LocaleKeys.buy.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
