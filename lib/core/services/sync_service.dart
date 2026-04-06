import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  Future<void> syncOfflineData() async {
    var connectivityResults = await (Connectivity().checkConnectivity());
    if (connectivityResults.contains(ConnectivityResult.none)) {
      return; // No internet
    }

    final unsynced = await DatabaseService.instance.getUnsyncedRecords();
    if (unsynced.isEmpty) return;

    for (var record in unsynced) {
      bool success = await _pushToAPI(record);
      if (success) {
        await DatabaseService.instance.markAsSynced(record['id'] as int);
      }
    }
  }

  Future<bool> _pushToAPI(Map<String, dynamic> record) async {
    try {
      // Mock API call to remote server
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // assume success
    } catch (e) {
      return false;
    }
  }
}
