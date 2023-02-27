import 'package:audioplayers/audioplayers.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_collection_model.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:intl/intl.dart';

class Utilities {
  static String? validateMobile(String value) {
    String pattern = r'(^(\+0?1\s)?((\d{3})|(\(\d{3}\)))?(\s|-)\d{3}(\s|-)\d{4}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static DateTime convertToLocalTime(DateTime serverTime) {
    Duration diff = DateTime.now().timeZoneOffset;
    return serverTime.add(diff);
  }

  static DateTime convertToServerTime(DateTime localTime) {
    Duration diff = DateTime.now().timeZoneOffset;
    return localTime.subtract(diff);
  }

  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static String formatDateTimeMessage(DateTime dateTime, {bool inline = true, bool onlyTime = false, bool onlyDate = false}) {
    DateTime now = DateTime.now();
    int difference = now.difference(dateTime).inMinutes;
    if (difference < 1) {
      return 'just now';
    } else if (difference < 10) {
      return '$difference mins ago';
    } else {
      bool isSameDay = dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
      if (isSameDay) {
        return onlyTime ? DateFormat('HH:mm').format(dateTime) : 'Today';
      } else {
        int deltaYear = now.year - dateTime.year;
        if (dateTime.year != now.year) return "$deltaYear year${deltaYear > 1 ? 's' : ''} ago";
        if (onlyDate) return DateFormat('MMMM dd').format(dateTime);
        if (inline) return DateFormat('HH:mm, MMMM dd').format(dateTime);
        return DateFormat('MMMM dd \n HH:mm').format(dateTime);
      }
    }
  }

  static String formatStickyDateLabel(DateTime date) {
    DateTime dateTime = DateTime(date.year, date.month, date.day);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (dateTime == today) {
      return "Today";
    } else if (dateTime == yesterday) {
      return "Yesterday";
    } else if (dateTime.year == now.year) {
      return DateFormat('MMMM dd').format(dateTime);
    } else {
      return DateFormat('yyyy/dd/MM').format(dateTime);
    }
  }

  static List<ConversationItemModel> filterByType(List<ConversationItemModel> conversations, ConversationType type) {
    return conversations.where((element) => element.type == type).toList();
  }

  static List<ConversationItemModel> filterByPhone(List<ConversationItemModel> conversations, String phone) {
    return conversations.where((element) => element.from == phone || element.to == phone).toList();
  }

  static List<ConversationCollectionModel> sortConversationsByPhone(List<ConversationItemModel> conversations) {
    List<ConversationCollectionModel> result = [];
    List<String?> callers = conversations.map((e) => e.isMine! ? e.to : e.from).toSet().toList();
    for (var caller in callers) {
      List<ConversationItemModel> callerConversations = conversations.where((element) => element.from == caller || element.to == caller).toList();
      callerConversations.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      result.add(ConversationCollectionModel(phone: caller!, conversations: callerConversations));
    }
    result.sort((a, b) => b.conversations.last.createdAt!.compareTo(a.conversations.last.createdAt!));
    return result;
  }

  static Map<DateTime, List<ConversationItemModel>> sortConversationsByDate(List<ConversationItemModel> conversations) {
    Map<DateTime, List<ConversationItemModel>> result = {};
    List<DateTime> dates = conversations.map((e) => e.getCreatedDate()).toSet().toList();
    dates.sort((a, b) => b.compareTo(a),);
    for (var date in dates) {
      List<ConversationItemModel> dateConversations = conversations.where((element) => element.getCreatedDate() == date).toList();
      result.putIfAbsent(date, () => dateConversations);
    }
    return result;
  }

  static Map<DateTime, List<ConversationCollectionModel>> sortCollectionsByDate(List<ConversationCollectionModel> collections) {
    Map<DateTime, List<ConversationCollectionModel>> result = {};
    List<DateTime> dates = collections.map((e) => e.getLastDate()).toSet().toList();
    for (var date in dates) {
      List<ConversationCollectionModel> labelCollections = collections.where((element) => date == element.getLastDate()).toList();
      result.putIfAbsent(date, () => labelCollections);
    }
    return result;
  }

  static final AudioCache player = AudioCache();
  static playSound(String path) => player.play(path);
}