import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_expense_manager/providers/settings_provider.dart';
import 'package:flutter_expense_manager/providers/expense_provider.dart';
import 'package:flutter_expense_manager/utils/app_utils.dart';
import 'package:flutter_expense_manager/utils/hive_utils.dart';
import 'package:flutter_expense_manager/utils/io_utils.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class BackupRestorePage extends StatelessWidget {
  const BackupRestorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup and Restore"),
      ),
      body: ListView(
        children: [
          Consumer<SettingsProvider>(
            builder: (_, provider, __) => ListTile(
              title: const Text("Backups Location"),
              subtitle: Text(provider.settings.appPath),
              onTap: () async {
                if (!provider.settings.hasManagePermission) {
                  provider.settings.hasManagePermission =
                      await AppUtils.getPermission(
                    Permission.manageExternalStorage,
                  );
                }
                if (provider.settings.hasManagePermission) {
                  var path = await IOUtils.folderPicker("Choose App Directory");
                  if (path != null) {
                    provider.updateAppPath(path);
                  }
                } else {
                  showSnackBar(
                    const Text(
                      "Failed to Get Permission",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Create Backup"),
            subtitle: const Text("Create backup of current data"),
            onTap: () async {
              await HiveUtils.closeBoxex();
              var done = await AppUtils.createBackup(
                appSettings: settingsProvider,
                model: expenseProvider,
              );
              if (done) {
                showSnackBar(
                  Text(
                    "Data Backup to ${settingsProvider.settings.backupPath}",
                  ),
                );
              } else {
                showSnackBar(
                  const Text(
                    "Failed to Create Backup",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }
              await HiveUtils.openBoxex();
              // IOUtils.folderPicker("Select Backup Folder").then((value) async {
              //   if (value != null) {}
              // });
            },
          ),
          ListTile(
            title: const Text("Restore backup"),
            subtitle: const Text("Restore data from backup file"),
            onTap: () {
              IOUtils.filePicker(
                  dialogTitle: "Select Backup Data Folder",
                  extensions: ["zip"]).then((value) async {
                if (value.isNotEmpty) {
                  await AppUtils.restoreBackup(value.first,
                      appSettings: settingsProvider);
                  await HiveUtils.reOpen();
                  expenseProvider.load();
                  showSnackBar(const Text("Data Restored"));
                }
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Export As Json"),
            onTap: () async {
              var loc = await expenseProvider.export(
                settingsProvider.settings.backupPath,
              );
              showSnackBar(
                Text(
                  "Data Exported to $loc",
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Import Json"),
            onTap: () async {
              var loc = await expenseProvider
                  .import(settingsProvider.settings.backupPath);
              if (loc.isNotEmpty) {
                showSnackBar(
                  Text(
                    "Data Imported from $loc",
                  ),
                );
              } else {
                showSnackBar(
                  const Text(
                    "Failed to Import Data",
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
