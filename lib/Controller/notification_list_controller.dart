import 'package:get/get.dart';

class NotificationListController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications.value = [
      NotificationItem(
        id: '1',
        userName: 'Olivia',
        userImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        mainText: 'followed you',
        secondaryText: 'Check out their profile',
        timestamp: '5 min ago',
        isRead: false,
        section: 'Today',
      ),
      NotificationItem(
        id: '2',
        userName: 'Ava',
        userImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        mainText: 'Commented on',
        secondaryText: 'your post',
        timestamp: '12 min ago',
        isRead: false,
        section: 'Today',
      ),
      NotificationItem(
        id: '3',
        userName: 'ashnoon',
        userImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        mainText: 'Liked your post',
        secondaryText: 'Check out their profile →',
        timestamp: '1 day ago',
        isRead: true,
        section: 'Yesterday',
      ),
      NotificationItem(
        id: '4',
        userName: 'Emma',
        userImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        mainText: 'sent a connection request',
        secondaryText: '',
        timestamp: '1 day ago',
        isRead: false,
        section: 'Yesterday',
      ),
      NotificationItem(
        id: '5',
        userName: 'Sophia',
        userImageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        mainText: 'Loved your photo',
        secondaryText: 'Check out their profile →',
        timestamp: '1 day ago',
        isRead: true,
        section: 'Yesterday',
      ),
      NotificationItem(
        id: '6',
        userName: 'Isabella',
        userImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        mainText: "It's your match!",
        secondaryText: 'Check out his profile →',
        timestamp: 'One week ago',
        isRead: false,
        section: 'This Week',
      ),
      NotificationItem(
        id: '7',
        userName: 'Charlotte',
        userImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        mainText: 'sent a connection request',
        secondaryText: '',
        timestamp: 'One week ago',
        isRead: false,
        section: 'This Week',
      ),
      NotificationItem(
        id: '8',
        userName: 'Amelia',
        userImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        mainText: 'Loved your photo' ,
        secondaryText: 'Check out their profile →',
        timestamp: 'One week ago',
        isRead: true,
        section: 'This Week',
      ),
    ];
  }

  List<NotificationItem> getNotificationsBySection(String section) {
    return notifications.where((notification) => notification.section == section).toList();
  }

  List<String> getSections() {
    return ['Today', 'Yesterday', 'This Week'];
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }
}

class NotificationItem {
  final String id;
  final String userName;
  final String userImageUrl;
  final String mainText;
  final String secondaryText;
  final String timestamp;
  bool isRead;
  final String section;

  NotificationItem({
    required this.id,
    required this.userName,
    required this.userImageUrl,
    required this.mainText,
    required this.secondaryText,
    required this.timestamp,
    required this.isRead,
    required this.section,
  });
}

