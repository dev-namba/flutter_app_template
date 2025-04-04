import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/res/button_style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/custom_hooks/use_effect_once.dart';
import '../../../../core/custom_hooks/use_form_field_state_key.dart';
import '../../../../core/entities/typedef.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/dialogs/show_content_dialog.dart';
import '../../../../core/widgets/show_indicator.dart';
import '../../entities/memo.dart';

Future<void> showEditMemoDialog(
  BuildContext context, {
  Memo? data,
  required Future<ErrorMessage?> Function(String text, bool isUpdate) onSave,
}) =>
    showContentDialog<void>(
      context: context,
      contentWidget: _Dialog(data, onSave),
    );

class _Dialog extends HookConsumerWidget {
  const _Dialog(
    this.data,
    this.onSave,
  );

  final Memo? data;
  final Future<ErrorMessage?> Function(String text, bool isUpdate) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textKey = useFormFieldStateKey();

    useEffectOnce(() {
      textKey.currentState?.didChange(data?.text);
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextFormField(
            key: textKey,
            initialValue: data?.text,
            style: context.bodyStyle,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? '正しい値を入力してください'
                : null,
            decoration: const InputDecoration(
              labelText: 'テキスト入力',
              hintText: '',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 3,
            maxLength: 1024,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton(
            style: ButtonStyles.normal(),
            onPressed: () async {
              if (textKey.currentState?.validate() != true) {
                return;
              }
              final text = textKey.currentState?.value?.trim() ?? '';
              context.hideKeyboard();
              final isUpdate = data != null;

              /// Providerを使った複数のサンプルコードがあるので、保存処理は呼び元へ委ねる
              showIndicator(context);
              final errorMessage = await onSave(text, isUpdate);
              if (context.mounted) {
                dismissIndicator(context);
                if (errorMessage == null) {
                  context.showSnackBar(isUpdate ? '更新しました' : '作成しました');
                  Navigator.pop(context);
                } else {
                  showOkAlertDialog(context: context, title: errorMessage)
                      .ignore();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                '投稿する',
                style: context.bodyStyle
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
