import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);
  }

  void showFullScreenNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'full_screen_channel_id',
        'Full Screen Notifications',
        channelDescription: 'Full screen notifications channel',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Alarm', 'Your alarm is ringing', platformChannelSpecifics,
        payload: 'alarm_payload');
  }

  void onSelectNotification(NotificationResponse response) async {
    if (response.payload != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AlarmScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showFullScreenNotification,
          child: Text('Show Full Screen Notification'),
        ),
      ),
    );
  }
}

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              'Incoming Call',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 50,
            child: AnimatedButton(
              icon: Icons.call_end,
              color: Colors.red,
              onTap: () {
                // Handle reject call
              },
            ),
          ),
          Positioned(
            right: 30,
            bottom: 50,
            child: AnimatedButton(
              icon: Icons.call,
              color: Colors.green,
              onTap: () {
                // Handle accept call
              }, key: null,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const AnimatedButton({
     Key? key,
     this.icon,
     this.color,
     this.onTap,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color?.withOpacity(0.5),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}




// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   @override
//   void initState() {
//     super.initState();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);
//   }
//
//   void showFullScreenNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//         'full_screen_channel_id',
//         'Full Screen Notifications',
//         channelDescription: 'Full screen notifications channel',
//         importance: Importance.max,
//         priority: Priority.high,
//         fullScreenIntent: true);
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'Alarm', 'Your alarm is ringing', platformChannelSpecifics,
//         payload: 'alarm_payload');
//   }
//
//   void onSelectNotification(NotificationResponse response) async {
//     if (response.payload != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => AlarmScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: showFullScreenNotification,
//           child: Text('Show Full Screen Notification'),
//         ),
//       ),
//     );
//   }
// }
//
// class AlarmScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alarm Screen'),
//       ),
//       body: Center(
//         child: Text('This is the full-screen alarm screen.'),
//       ),
//     );
//   }
// }
