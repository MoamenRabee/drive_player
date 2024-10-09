library drive_player;

import 'dart:developer';

import 'package:drive_player/drive_api.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class DrivePlayer extends StatefulWidget {
  DrivePlayer({super.key, required this.drivelink});

  String drivelink;

  @override
  State<DrivePlayer> createState() => _DrivePlayerState();
}

class _DrivePlayerState extends State<DrivePlayer> {
  bool isLoading = true;
  late final PodPlayerController controller;

  @override
  void initState() {
    String? videoId = DriveApi.getFileId(widget.drivelink);
    DriveApi.getDirectLinkFromDrive(videoId ?? '').then((directLink) {
      if (directLink == null) return;
      log('directLink : $directLink');

      isLoading = false;
      setState(() {});

      controller = PodPlayerController(playVideoFrom: PlayVideoFrom.network(directLink))..initialise().then((_) {});
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) {
        return const Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 5, color: Colors.black)));
      }
      return PodVideoPlayer(controller: controller);
    });
  }
}
