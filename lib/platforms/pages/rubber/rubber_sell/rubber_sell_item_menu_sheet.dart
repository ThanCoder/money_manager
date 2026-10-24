import 'package:flutter/material.dart';
import 'package:money_manager/core/controller/i_controller.dart';
import 'package:money_manager/core/controller/rubber_sell_record_controller.dart';
import 'package:money_manager/core/controller/rubber_site_controller.dart';
import 'package:money_manager/core/models/rubber/rubber_sell_record.dart';
import 'package:money_manager/core/models/worker/my_work_site.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_home/new_rubber_sell_sheet.dart';
import 'package:money_manager/platforms/pages/rubber/rubber_sell/rubber_sell_delete_item_menu_sheet.dart';
import 'package:t_widgets/t_widgets.dart';

class RubberSellItemMenuSheet extends StatefulWidget {
  const new({super.key, required this.record, required this.site});
  final RubberSellRecord record;
  final MyWorkSite site;

  @override
  State<RubberSellItemMenuSheet> createState() =>
      _RubberSellItemMenuSheetState();

  static Future<void> show(
    BuildContext context, {
    required RubberSellRecord record,
    required MyWorkSite site,
  }) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => RubberSellItemMenuSheet(record: record, site: site),
    );
  }
}

class _RubberSellItemMenuSheetState extends State<RubberSellItemMenuSheet> {
  final sellRecCon = ControllerManager.read<RubberSellRecordController>();
  final rubberCon = ControllerManager.read<RubberSiteController>();

  void _showNewRubberSellSheet(RubberSellRecord record) async {
    await NewRubberSellSheet.show(
      context,
      site: widget.site,
      editRecord: record,
      onSave: (resp) async {
        for (var wd in resp.dailyWorks) {
          await rubberCon.update(wd.generatedId, wd.copyWith(paid: true));
        }
        await sellRecCon.update(record.generatedId, resp.record);
      },
    );
  }

  void deleteMenu() {
    RubberSellDeleteItemMenuSheet.show(
      context,
      record: widget.record,
      site: widget.site,
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        children: [
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text('Edit'),
            onTap: () {
              context.pop();
              _showNewRubberSellSheet(widget.record);
            },
          ),
          ListTile(
            tileColor: col.error,
            leading: Icon(Icons.delete_forever_outlined, color: col.onError),
            title: Text('Delete', style: TextStyle(color: col.onError)),
            onTap: () {
              context.pop();
              deleteMenu();
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
