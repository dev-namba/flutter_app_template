import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/custom_hooks/use_effect_once.dart';
import '../../../core/custom_hooks/use_refresh_controller.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/extensions/scroll_controller_extension.dart';
import '../../../core/utils/tab_tap_operation_provider.dart';
import '../../../core/widgets/images/thumbnail.dart';
import '../../../core/widgets/smart_refresher/smart_refresher_custom.dart';
import '../use_cases/github_users_controller.dart';
import 'widgets/error_message.dart';

class GithubUsersPage extends HookConsumerWidget {
  const GithubUsersPage({super.key});
  static String get pageName => 'github_users';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubUsers = ref.watch(githubUsersControllerProvider);
    final scrollController = useScrollController();
    final refreshController = useRefreshController();
    final tabTapOperation = ref.watch(tabTapOperationProviders(pageName));

    useEffectOnce(() {
      /// 同じタブが選択された場合、上にスクロールする
      tabTapOperation.addListener((value) {
        if (value == TabTapOperationType.duplication) {
          scrollController.animateToTop();
        }
      });
      return null;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Github Users',
          style: context.subtitleStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: githubUsers.when(
        data: (items) {
          return SmartRefresher(
            header: const SmartRefreshHeader(),
            footer: const SmartRefreshFooter(),
            enablePullUp: true,
            controller: refreshController,
            physics: const BouncingScrollPhysics(),
            onRefresh: () {
              ref.invalidate(githubUsersControllerProvider);
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await ref
                  .read(githubUsersControllerProvider.notifier)
                  .onFetchMore();
              refreshController.loadComplete();
            },
            child: ListView.separated(
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) {
                final data = items[index];
                return ListTile(
                  leading: CircleThumbnail(size: 40, url: data.avatarUrl),
                  title: Text(data.login, style: context.bodyStyle),
                  subtitle: Text(
                    data.htmlUrl ?? '-',
                    style: context.smallStyle,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    final url = data.htmlUrl;
                    if (url != null) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1);
              },
              itemCount: items.length,
            ),
          );
        },
        error:
            (e, _) => ErrorMessage(
              message: e.toString(),
              onTapRetry: () {
                ref.invalidate(githubUsersControllerProvider);
              },
            ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
