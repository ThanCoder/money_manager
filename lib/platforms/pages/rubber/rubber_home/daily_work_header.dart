import 'package:material_ui/material_ui.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_daily_work.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_sell/rubber_sell_home_page.dart';
import 'package:money_manager/ui/build_context_x.dart';

class DailyWorkHeader extends StatefulWidget {
  const new({super.key, required this.site});
  final MyWorkSite site;

  @override
  State<DailyWorkHeader> createState() => _DailyWorkHeaderState();
}

class _DailyWorkHeaderState extends State<DailyWorkHeader> {
  final con = ControllerManager.read<RubberSiteController>();
  final sellRecCon = ControllerManager.read<RubberSellRecordController>();

  final currentDate = DateTime.now();

  void goRubberSellPage() {
    context.pushMaterialPageRoute(
      builder: (mainCtx) => RubberSellHomePage(site: widget.site),
    );
  }

  int? get currentDayRubberSlice {
    for (var d in con.list) {
      if (d.endWorkTime.month == currentDate.month &&
          d.endWorkTime.day == currentDate.day) {
        return d.rubberSliceCount;
      }
    }
    return null;
  }

  int get unpaidRubberSlices {
    return con.list.fold(0, (prev, ele) {
      if (!ele.paid) {
        return prev + ele.rubberSliceCount;
      }
      return prev;
    });
  }

  int get unpaidRubberDailyWorked {
    return con.list.fold(0, (prev, ele) {
      if (!ele.paid) {
        return prev + 1;
      }
      return prev;
    });
  }

  List<Widget> get headerList => [
    if (currentDayRubberSlice != null)
      _SummaryCard(
        icon: Icons.eco_outlined,
        title: 'ယနေ့ အစီးပြား',
        value: currentDayRubberSlice.toString(),
        suffix: ' slices',
      ),
    _SummaryCard(
      icon: Icons.eco_outlined,
      title: 'မရောင်းရသေးတဲ့ အစီးပြား',
      value: unpaidRubberSlices.toString(),
      suffix: ' slices',
    ),
    if (con.list.isNotEmpty)
      _SummaryCard(
        icon: Icons.calendar_month_outlined,
        title: 'အလုပ်လုပ်ခဲ့တဲ့နေ့',
        value: '${con.list.length}',
      ),
    if (unpaidRubberDailyWorked > 0)
      _SummaryCard(
        icon: Icons.calendar_month_outlined,
        title: 'မရောင်းရသေးတဲ့ အလုပ်နေ့များ',
        value: '$unpaidRubberDailyWorked',
      ),
    if (sellRecCon.list.isNotEmpty)
      _SummaryCard(
        icon: Icons.payments_outlined,
        title: 'အလုပ်လုပ်ခဲ့တဲ့ အချိန်',
        value: con.list.totalWorkTimeLable,
      ),
    InkWell(
      borderRadius: .circular(18),
      onTap: goRubberSellPage,
      child: _SummaryCard(
        icon: Icons.payments_outlined,
        title: 'အရင်အပတ်က ဝင်ငွေ',
        value: sellRecCon.list.isEmpty
            ? '0'
            : '${sellRecCon.list.last.workerSellMoney}',
        suffix: ' MMK >',
      ),
    ),
  ];

  ColorScheme get col => context.colorScheme;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [SliverPadding(padding: .all(8), sliver: _header())],
    );
  }

  SliverToBoxAdapter _header() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          StreamBuilder(
            stream: con.events.whereType<RubberSiteDataChanged>(),
            builder: (context, asyncSnapshot) {
              return Wrap(spacing: 5, runSpacing: 5, children: headerList);
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String suffix;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),

          const SizedBox(height: 12),

          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(text: value),
                if (suffix.isNotEmpty)
                  TextSpan(
                    text: suffix,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
