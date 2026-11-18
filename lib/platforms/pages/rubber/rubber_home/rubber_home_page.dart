import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/add_rubber_daily_work_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/daily_work_header.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/daily_work_list.dart';

class RubberHomePage extends StatefulWidget {
  const new({super.key, required this.site});
  final MyWorkSite site;

  @override
  State<RubberHomePage> createState() => _RubberHomePageState();
}

class _RubberHomePageState extends State<RubberHomePage> {
  late MyWorkSite site;
  @override
  void initState() {
    site = widget.site;
    init();
    super.initState();
  }

  final con = ControllerManager.read<RubberSiteController>();
  final sellRecCon = ControllerManager.read<RubberSellRecordController>();

  final currentDate = DateTime.now();

  Future<void> init() async {
    await con.fetchList(widget.site.id);
    await sellRecCon.fetchList(widget.site.id);
  }

  void _showAddDailyWork(BuildContext context) {
    AddRubberDailyWorkSheet.show(
      context,
      sites: [widget.site],
      lastWork: con.list.firstOrNull,
      onSave: (work) {
        con.add(work);
      },
    );
  }

  void showMenu() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            _appbar(),

            DailyWorkHeader(site: widget.site),

            // SliverPadding(
            //   padding: const EdgeInsets.all(16),
            //   sliver: _header(theme),
            // ),

            // Daily work list
            DailyWorkList(site: widget.site),
            SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddDailyWork(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Daily Work'),
      ),
    );
  }

  SliverAppBar _appbar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: false,
      title: Text(widget.site.title),
      actions: [
        if (TPlatform.isDesktop)
          IconButton(onPressed: init, icon: const Icon(Icons.refresh_rounded)),
        IconButton(onPressed: showMenu, icon: const Icon(Icons.more_vert)),
      ],
    );
  }
}
