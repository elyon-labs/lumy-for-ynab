import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Markdown extends StatelessWidget {
  const Markdown({super.key, required this.data, this.onTapLink, this.selectable = true});

  final String data;
  final ValueSetter<String>? onTapLink;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    Future<void> onTapLink(String url) async {
      if (this.onTapLink != null) {
        this.onTapLink!(url);
        return;
      }

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }

    return MarkdownBlock(
      selectable: selectable,
      config: MarkdownConfig(
        configs: [
          context.headingConfig(tag: 'h1'),
          context.headingConfig(tag: 'h2'),
          context.headingConfig(tag: 'h3'),
          context.headingConfig(tag: 'h4'),
          context.headingConfig(tag: 'h5'),
          context.headingConfig(tag: 'h6'),
          PConfig(textStyle: context.text.body),
          LinkConfig(
            style: context.text.body.copyWith(
              color: context.colors.accent,
              decoration: TextDecoration.underline,
            ),
            onTap: onTapLink,
          ),
        ],
      ),
      data: data,
    );
  }
}

extension on BuildContext {
  HeadingConfig headingConfig({required String tag}) {
    return _HeadingConfig(style: text.headline, tag: tag);
  }
}

class _HeadingConfig extends HeadingConfig {
  const _HeadingConfig({required this.style, required this.tag});

  @override
  final TextStyle style;

  @override
  final String tag;

  @override
  HeadingDivider? get divider => null;
}
