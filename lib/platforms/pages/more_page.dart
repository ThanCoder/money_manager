import 'package:material_ui/material_ui.dart';
import 'package:money_manager/platforms/pages/app_about_dialog.dart';
import 'package:money_manager/platforms/pages/db_setting/db_setting_page.dart';
import 'package:money_manager/ui/index.dart';

import 'dev_pages/dev_route_tile.dart';
import 'version_manager.dart';

class MorePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: ScrollableColumn(
        padding: .symmetric(vertical: 10, horizontal: 15),
        children: [
          MaterialThemeProviderChooser(),
          VersionManager(
            githubUrl: 'https://github.com/ThanCoder/mony_manager',
          ),
          // CacheManagerListTile(
          //   cacheDirPath: AppUtil.instance.getPlatformCachePath(),
          // ),
          DBSettingListTile(),

          DevRouteTile(),
          AppAboutDialogListTile(descText: 'ငွေကြေးစီမံရေး Application.'),
        ],
      ),
    );
  }
}
