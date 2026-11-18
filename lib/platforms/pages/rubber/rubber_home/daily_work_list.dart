import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_daily_work.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/rubber_daily_work_detail_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/rubber_item_menu.dart';
import 'package:money_manager/ui/index.dart';

class DailyWorkList extends StatefulWidget {
  const new({super.key, required this.site});
  final MyWorkSite site;

  @override
  State<DailyWorkList> createState() => _DailyWorkListState();
}

class _DailyWorkListState extends State<DailyWorkList> {
  final con = ControllerManager.read<RubberSiteController>();

  void showRubberDetail(RubberDailyWork work) {
    RubberDailyWorkDetailSheet.show(context, work: work);
  }

  void showRubberItemMenu(RubberDailyWork work) {
    RubberItemMenu.show(context, work, site: widget.site);
  }

  void viewAll() {}

  ColorScheme get col => context.colorScheme;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Daily Work',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: viewAll, child: const Text('View All')),
              ],
            ),
          ),
        ),
        _listWidget(),
      ],
    );
  }

  Widget _listWidget() {
    return StreamBuilder(
      stream: con.events.whereType<RubberSiteDataChanged>(),
      builder: (context, asyncSnapshot) {
        if (con.list.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text('စာရင်းမရှိပါ')),
          );
        }
        return SliverList.builder(
          itemCount: con.list.length,
          itemBuilder: (context, index) {
            return _dailyWorkItem(con.list[index]);
          },
        );
      },
    );
  }

  Widget _dailyWorkItem(RubberDailyWork rubber) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bgColor = rubber.paid
        ? colorScheme.surfaceBright
        : colorScheme.primaryContainer;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showRubberDetail(rubber),
        onLongPress: () => showRubberItemMenu(rubber),
        onSecondaryTap: () => showRubberItemMenu(rubber),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: .circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.eco_outlined,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    Text(
                      '${rubber.startWorkTime.formatTime()}  →  ${rubber.endWorkTime.formatTime()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(rubber.dateLabel),
                  ],
                ),
              ),
              Expanded(child: Text(rubber.paid ? 'ရောင်းပြီး' : 'မရောင်းရသေး')),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${rubber.rubberSliceCount}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'slices',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
