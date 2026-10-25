import 'package:dual_store/dual_store.dart';
import 'package:money_manager/core/datetime_x.dart';

class RubberDailyWorkAdapter extends IDuBinaryMetaAdapter<RubberDailyWork> {
  @override
  int get adapterId => 2;

  @override
  RubberDailyWork fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(RubberDailyWork value) {
    return value.toJson();
  }
}

class RubberDailyWork extends IDuModel {
  RubberDailyWork({
    required this.siteId,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.rubberSliceCount,
    required this.paid,
    required this.id,
  });
  final String id;
  final String siteId;
  final DateTime startWorkTime;

  final DateTime endWorkTime;

  /// Number of rubber slices.
  final int rubberSliceCount;
  final bool paid;

  String get date {
    if (endWorkTime.isToday) return 'Today';
    final d = endWorkTime;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteId': siteId,
      'startWorkTime': startWorkTime.millisecondsSinceEpoch,
      'endWorkTime': endWorkTime.millisecondsSinceEpoch,
      'rubberSliceCount': rubberSliceCount,
      'paid': paid,
    };
  }

  factory RubberDailyWork.fromJson(Map<String, dynamic> json) {
    String siteId = '';
    if (json['siteId'] case {'id': var id}) {
      siteId = id;
    } else if (json['siteId'] is String) {
      siteId = json['siteId'] as String;
    }
    // final site = MyWorkSite.fromJson();

    return RubberDailyWork(
      id: json['id'],
      siteId: siteId,
      startWorkTime: DateTime.fromMillisecondsSinceEpoch(json['startWorkTime']),
      endWorkTime: DateTime.fromMillisecondsSinceEpoch(json['endWorkTime']),
      rubberSliceCount: json['rubberSliceCount'],
      paid: json['paid'],
    );
  }

  @override
  String toString() {
    return '''RubberDailyWork(id: $id, siteId: $siteId, startWorkTime: $startWorkTime, endWorkTime: $endWorkTime, rubberSliceCount: $rubberSliceCount, paid: $paid)''';
  }

  RubberDailyWork copyWith({
    String? id,
    String? siteId,
    DateTime? startWorkTime,
    DateTime? endWorkTime,
    int? rubberSliceCount,
    bool? paid,
  }) {
    return RubberDailyWork(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      startWorkTime: startWorkTime ?? this.startWorkTime,
      endWorkTime: endWorkTime ?? this.endWorkTime,
      rubberSliceCount: rubberSliceCount ?? this.rubberSliceCount,
      paid: paid ?? this.paid,
    );
  }
}

extension RubberDailyWorkListX on List<RubberDailyWork> {
  String get totalWorkTimeLable {
    final duration = Duration(minutes: totalMinutes);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '$hours နာရီ $minutes မိနစ်';
    }

    if (hours > 0) {
      return '$hours နာရီ';
    }

    return '$minutes မိနစ်';
  }

  int get totalHours {
    final totalMins = totalMinutes;
    return totalMins.remainder(60);
  }

  int get totalMinutes {
    return fold(0, (prev, e) => prev += e.totalWorkTimeMinutes);
  }

  void sortDate({bool newest = true}) {
    sort((a, b) {
      if (newest) {
        return b.endWorkTime.compareTo(a.endWorkTime);
      } else {
        return a.endWorkTime.compareTo(b.endWorkTime);
      }
    });
  }
}

extension RubberDailyWorkX on RubberDailyWork {
  int get totalWorkTimeMinutes {
    final duration = endWorkTime.difference(startWorkTime);

    // final hours = duration.inHours;
    // final minutes = duration.inMinutes.remainder(60);

    return duration.inMinutes;
  }
}
