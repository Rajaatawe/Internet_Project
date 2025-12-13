import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/notification_model.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<List<NotificationModel>> {
  final RemoteService _remoteDatasource;

  NotificationCubit({required this.remoteDatasource})
    : _remoteDatasource = remoteDatasource,
      super([]) {
    loadNotifications();
  }

  final RemoteService remoteDatasource;
  Future<void> addNotification(NotificationModel n) async {
    final updated = [...state, n];
    emit(updated);
    await saveNotifications(updated);
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notifications.map((n) => json.encode(n.toJson())).toList();
    await prefs.setStringList('notifications', jsonList);
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('notifications') ?? [];
    final notifications = jsonList
        .map((e) => NotificationModel.fromJson(json.decode(e)))
        .toList();
    emit(notifications);
  }

  Future<void> saveToken(
    String token,
    String deviceType,
    String platform,
  ) async {
    await remoteDatasource.performPostRequestNoRes("deviceToken", {
      "device_token": token,
      "device_type": deviceType,
      "platform": platform,
    }, useToken: false);
    emit(state);
  }
}
