import 'package:material_ui/material_ui.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/ui/index.dart';

class RubberSellDeleteItemMenuSheet extends StatefulWidget {
  const new({super.key, required this.record, required this.site});
  final RubberSellRecord record;
  final MyWorkSite site;

  @override
  State<RubberSellDeleteItemMenuSheet> createState() =>
      _RubberSellDeleteItemMenuSheetState();

  static Future<void> show(
    BuildContext context, {
    required RubberSellRecord record,
    required MyWorkSite site,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) =>
          RubberSellDeleteItemMenuSheet(record: record, site: site),
    );
  }
}

class _RubberSellDeleteItemMenuSheetState
    extends State<RubberSellDeleteItemMenuSheet> {
  final sellRecCon = ControllerManager.read<RubberSellRecordController>();
  final rubberCon = ControllerManager.read<RubberSiteController>();
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        children: [
          ListTile(
            tileColor: col.error,
            leading: Icon(Icons.delete_forever_outlined, color: col.onError),
            title: Text(
              'ရောင်းပြီးအလုပ်ရက် ပြန်ပြင်ချင်း',
              style: TextStyle(color: col.onError),
            ),
            subtitle: Text(
              'ရောင်းလို့သတ်မှာထားတဲ့ နေ့စဥ် အလုပ်လုပ်ခဲ့တဲ့နေ့ကို ပြန်လည် ပြောင်းလဲပြီး ဖျက်လိုက်မလား?',
              style: TextStyle(color: col.onError),
            ),
            onTap: () {
              context.pop();
            },
          ),
          ListTile(
            tileColor: col.error,
            leading: Icon(Icons.delete_forever_outlined, color: col.onError),
            title: Text(
              'တစ်ခါတည်း ဖျက်ပစ်ခြင်း',
              style: TextStyle(color: col.onError),
            ),
            subtitle: Text(
              'ဘာမှမလုပ်ဘဲ အခု စာရင်းကိုပဲ ဖျက်ပစ်ခြင်း',
              style: TextStyle(color: col.onError),
            ),
            onTap: () {
              context.pop();
              sellRecCon.delete(widget.record);
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
