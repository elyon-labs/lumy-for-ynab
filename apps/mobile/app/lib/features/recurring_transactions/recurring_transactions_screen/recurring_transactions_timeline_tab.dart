import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../common/presentation/design_system/list_row.dart';
import '../../../common/presentation/design_system/outlined_child.dart';
import '../../../common/presentation/design_system/section_body.dart';
import '../../../common/presentation/transactions/transaction_row.dart';
import '../../../utils/_local_date.dart';
import 'recurring_transactions_screen.dart';

class RecurringTransactionsTimelineTab extends HookWidget {
  const RecurringTransactionsTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    final timeline = context.watch<RecurringTransactionsScreenCubit>().state.timeline;

    if (timeline.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (timeline.isError) {
      return Center(child: Text(timeline.error.toString()));
    }

    final nodes = timeline.unwrap();

    return TimelineTheme(
      data: TimelineThemeData(
        indicatorTheme: IndicatorThemeData(color: context.colors.foreground, size: Sizes.unit * 3),
        connectorTheme: ConnectorThemeData(thickness: 2, color: context.colors.foreground),
        nodePosition: 0,
      ),
      child: Timeline.tileBuilder(
        padding: const EdgeInsets.all(Sizes.edgePadding),
        builder: TimelineTileBuilder.connectedFromStyle(
          itemCount: nodes.length,
          connectorStyleBuilder: (context, index) {
            return ConnectorStyle.solidLine;
          },
          indicatorStyleBuilder: (context, index) {
            final node = nodes.elementAt(index);
            return switch (node) {
              EmptyNode() => IndicatorStyle.outlined,
              TransactionsNode() => IndicatorStyle.dot,
            };
          },
          firstConnectorStyle: ConnectorStyle.transparent,
          lastConnectorStyle: ConnectorStyle.transparent,
          contentsBuilder: (context, index) {
            final node = nodes.elementAt(index);
            return switch (node) {
              EmptyNode(:final date) => ListRow(
                title: Text(
                  date.MMMdyyyy(),
                  style: context.text.caption.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              TransactionsNode(:final instances, :final date) => Padding(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.edgePadding,
                  Sizes.unit / 2,
                  0,
                  Sizes.unit / 2,
                ),
                child: OutlinedChild(
                  child: VLayout(
                    spacing: 0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Sizes.edgePadding,
                          top: Sizes.edgePadding,
                        ),
                        child: Text(
                          '${date.MMMdyyyy()}: ${instances.length} transaction${instances.length > 1 ? 's' : ''}',
                          style: context.text.caption.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListSection(
                        children: [
                          for (final instance in instances)
                            TransactionRow(transaction: instance.transaction),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
