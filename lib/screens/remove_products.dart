import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icare/providers/common_provider.dart';
import 'package:icare/utils/theme.dart';
import 'package:icare/utils/utils.dart';
import 'package:icare/widgets/app_modals.dart';
import 'package:icare/widgets/back_button.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:icare/widgets/seller_products.dart';

class RemoveProductsScreen extends ConsumerWidget {
  const RemoveProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var selectedReason = '';
    final reason = ref.watch(commonProvider).selectedReason;
    log('message : $reason');
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Remove Products",
          fontFamily: "Gilroy-Bold",
          fontSize: 16.78,
          fontWeight: FontWeight.bold,
          color: AppColors.primary500,
          letterSpacing: -0.31,
          lineHeight: 1.0,
        ),
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: GridView.builder(
        itemCount: 8,
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: Utils.windowHeight(context) * 0.25,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),

        itemBuilder: (ctx, i) {
          return (ProductCard(
            showRemove: true,
            onRemove: () {
              AppDialogs.showWarningDialog(
                context,
                "Are  you sure do you want to remove this item from phamacy?",
                null,
                ["Out of stock", "Backend Issue", "Other"],
                numOfActions: 2,
                primaryText: "Remove",
                secondaryText: "Not Now",
                onPrimaryButtonPressed: () {
                  AppDialogs.showSuccessDialog(
                    ctx,
                    title: "Removed Product Successfully",
                    description: "You’ve successfully removed your product.",
                  );
                },
              );
              // log("message : Remove product at index $i");
            },
          ));
        },
      ),
    );
  }
}
