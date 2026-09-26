import 'package:b2b_seller/core/common/screens/my_requests_screen.dart';
import 'package:b2b_seller/core/common/screens/my_reviews_screen.dart';
import 'package:b2b_seller/core/common/screens/payments_screen.dart';
import 'package:b2b_seller/core/common/screens/subscription_screen.dart';
import 'package:b2b_seller/core/common/widget/role_screen_widgets.dart';
import 'package:b2b_seller/src/auth/presentation/widget/logout_button.dart';
import 'package:flutter/material.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  static const path = '/buyer-profile';
  static const name = 'buyer-profile';

  @override
  Widget build(BuildContext context) {
    return const SectionMenu(
      title: 'Профиль',
      showProfileHeader: true,
      items:  [
        SectionMenuItem(
          icon: Icons.assignment_outlined,
          title: 'Мои заявки',
          path: MyRequestsScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Платежи',
          path: PaymentsScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.star_outline,
          title: 'Мои отзывы',
          path: MyReviewsScreen.path,
        ),
        SectionMenuItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Подписка',
          path: SubscriptionScreen.path,
        ),
      ],
      footer: LogOutButton(),
    );
  }
}
