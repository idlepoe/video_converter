const Map<String, String> zhTranslations = {
  // App Basic
  'video_converter': '视频转换器',
  'select_video': '选择视频',
  'select_video_file': '选择视频文件',
  'tap_to_select_video': '点击选择视频',
  'convert': '转换',
  'cancel': '取消',
  'go_back': '返回',
  'other_video': '其他视频',

  // Video Settings
  'fps': 'FPS',
  'quality': '质量',
  'resolution': '分辨率',
  'playback_speed': '播放速度',
  'convert_options': '转换选项',
  'output_format': '输出格式',

  // Privacy & Consent
  'privacy_protection': '隐私保护',
  'privacy_protection_message': '您的视频文件在本地处理，永远不会上传到外部服务器。',
  'file_deletion_info': '文件在本地处理，转换后可以安全删除。',

  // Video Information
  'file_name_label': '文件名:',
  'video_resolution_label': '分辨率:',
  'video_duration_label': '时长:',
  'file_size_label': '文件大小:',
  'original_file_size': '原始文件大小: @size',

  // Video Actions
  'video_rotate': '旋转视频',
  'video_trim': '修剪视频',

  // Video Trim
  'start_time': '开始时间',
  'end_time': '结束时间',
  'processing': '处理中...',
  'complete_video_trim': '视频修剪完成',
  'trim_error_message': '视频修剪失败。请重试。',
  'complete': '完成',

  // Video Rotate
  'rotate_angle_selection': '旋转角度选择',
  'rotate_video_initializing': '初始化中...',
  'rotate_video_preparing_ffmpeg': '准备FFmpeg命令...',
  'rotate_video_processing_ffmpeg': '处理视频旋转...',
  'rotate_video_checking_result': '检查结果...',
  'rotate_video_complete_status': '完成！',
  'rotate_video_processing_status': '处理中...',
  'rotate_video_thumbnail_warning_line1': '• 在屏幕上旋转视频时看到的分辨率失真是一个UI显示问题',
  'rotate_video_thumbnail_warning_line2': '• 实际上，原始视频的分辨率和质量都得到保持',
  'rotate_video_thumbnail_warning_line3': '• FFmpeg处理的最终文件以与原始文件相同的质量进行旋转',
  'rotate_video_processing': '旋转视频中...',
  'rotate_video_complete': '视频已旋转@angle°。',
  'rotate_video_error': '旋转视频时发生错误: @error',
  'rotate_video_file_not_created': '未创建旋转文件。',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': '不支持的旋转角度: @angle',
  'rotate_video_ffmpeg_error': 'FFmpeg执行失败: @error',
  'rotate_video_file_size_calculating': '计算文件大小中...',
  'rotate_video_thumbnail_warning_title': '重要通知',

  // Format Descriptions
  'format_webp_description': '动画WebP → 作为视频处理',
  'format_mp4_description': 'H.264/H.265，AAC/MP3/Opus音频组合',
  'format_mkv_description': 'H.264/H.265/VP9，Opus/Vorbis/MP3等',
  'format_avi_description': 'MPEG-4 Part 2，MP3等',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime，H.264，AAC，MP3等',

  // Loading & Conversion
  'converting': '转换中...',
  'progress_estimate': '进度条是估算值。实际转换速度可能有所不同。',
  'still_working': '仍在努力处理您的视频！ 🚀',
  'keep_app_open': '请保持应用打开以确保流畅转换！🎬',
  'preparing_conversion': '准备转换...',
  'no_video_selected': '未选择视频文件',
  'starting_conversion': '开始转换...',
  'converting_to_format': '转换为@format（质量: @quality%，FPS: @fps）...',
  'saving_to_gallery': '保存到相册...',
  'conversion_completed_saved': '转换完成并保存到相册！',
  'conversion_completed_not_saved': '转换完成但保存到相册失败',
  'conversion_completed_gallery_failed': '转换完成但相册保存失败: @error',
  'conversion_failed': '转换失败',
  'conversion_error': '转换错误: @error',

  // Error Messages
  'error_ffmpeg_not_available': '此设备不支持视频处理功能',
  'error_rotation_filter_not_supported': '此设备不支持视频旋转滤镜',
  'error_format_not_supported': '此设备不支持所选格式',
  'error_memory_insufficient': '视频转换内存不足',
  'error_rotation_general': '视频旋转时发生错误: @error',
  'error_conversion_general': '视频转换时发生错误: @error',

  // Convert Result
  'conversion_complete': '转换完成',
  'conversion_complete_title': '转换完成！',
  'no_converted_file': '未找到转换文件',
  'video_saved_to_gallery': '视频已保存到相册',
  'file_ready_for_download': '文件准备下载',
  'format_webp': '格式: WebP',
  'saved_to_gallery': '已保存到相册',
  'not_saved_to_gallery': '未保存到相册',
  'gallery_save_success_message': '您转换的视频现在可以在相册中使用',
  'gallery_save_failed_message': '保存到相册失败。请检查文件权限。',
  'convert_another': '转换其他视频',
  'view_in_gallery': '在相册中查看',
  'unknown': '未知',
  'gallery_app_not_found': '未找到相册应用。请手动检查您的相册。',

  // Notifications
  'notification_conversion_complete_title': '🎬 视频转换完成！',
  'notification_conversion_complete_message':
      '@fileName已成功转换为@format并保存到您的相册中。',
  'notification_conversion_error_title': '❌ 转换失败',
  'notification_conversion_error_message': '视频转换失败：@errorMessage',
};
