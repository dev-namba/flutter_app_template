import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../features/app_wrapper/pages/main_page.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/res/button_style.dart';
import '../use_cases/local_counter.dart';

class LocalCounterPage extends HookConsumerWidget {
  const LocalCounterPage({super.key});

  static String get pageName => 'local_counter';
  static String get pagePath => '${MainPage.pagePath}/$pageName';

  /// go_routerの画面遷移
  static void push(BuildContext context) {
    context.push(pagePath);
  }

  /// 従来の画面遷移
  static Future<void> showNav1(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        settings: RouteSettings(name: pageName),
        builder: (_) => const LocalCounterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(localCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ローカルカウンター',
          style: context.subtitleStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ローカル',
            style: context.bodyStyle,
          ),
          Text(
            key: const Key('counter'),
            counter.toString(),
            style: context.titleStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FilledButton(
                    style: ButtonStyles.normal(),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await ref.read(localCounterProvider.notifier).decrement();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: FilledButton(
                    style: ButtonStyles.normal(),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await ref.read(localCounterProvider.notifier).increment();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
