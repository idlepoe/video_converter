const Map<String, String> enTranslations = {
  // App Basic
  'video_converter': 'Video Converter',
  'select_video': 'Select Video',
  'select_video_file': 'Select Video File',
  'tap_to_select_video': 'Tap to select a video',
  'convert': 'Convert',
  'convert_video_count': 'Convert @count videos',
  'cancel': 'Cancel',
  'go_back': 'Go Back',
  'press_back_again_to_exit': 'Press back again to exit',
  'other_video': 'Other Video',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Quality',
  'resolution': 'Resolution',
  'playback_speed': 'Playback Speed',
  'convert_options': 'Convert Options',
  'output_format': 'Output Format',

  // Privacy & Consent
  'privacy_protection': 'Privacy Protection',
  'privacy_protection_message':
      'Your video files are processed locally and never uploaded to external servers.',
  'file_deletion_info':
      'Files are processed locally and can be safely deleted after conversion.',

  // Video Information
  'file_name_label': 'File Name:',
  'video_resolution_label': 'Resolution:',
  'video_duration_label': 'Duration:',
  'file_size_label': 'File Size:',
  'original_file_size': 'Original File Size: @size',

  // Video Actions
  'video_rotate': 'Video Rotate',
  'video_trim': 'Video Trim',

  // Video Trim
  'start_time': 'Start Time',
  'end_time': 'End Time',
  'processing': 'Processing...',
  'complete_video_trim': 'Complete Video Trim',
  'trim_error_message': 'Failed to trim video. Please try again.',
  'complete': 'Complete',

  // Video Rotate
  'rotate_angle_selection': 'Rotate Angle Selection',
  'rotate_video_initializing': 'Initializing...',
  'rotate_video_preparing_ffmpeg': 'Preparing FFmpeg command...',
  'rotate_video_processing_ffmpeg': 'Processing video rotation...',
  'rotate_video_checking_result': 'Checking result...',
  'rotate_video_complete_status': 'Complete!',
  'rotate_video_processing_status': 'Processing...',
  'rotate_video_thumbnail_warning_line1':
      '• The resolution distortion you see when rotating video on screen is a UI display issue',
  'rotate_video_thumbnail_warning_line2':
      '• Actually, the original video resolution and quality are maintained',
  'rotate_video_thumbnail_warning_line3':
      '• The final file processed by FFmpeg is rotated with the same quality as the original',
  'rotate_video_processing': 'Rotating video...',
  'rotate_video_complete': 'Video has been rotated @angle°.',
  'rotate_video_error': 'An error occurred while rotating video: @error',
  'rotate_video_file_not_created': 'Rotated file was not created.',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'Unsupported rotation angle: @angle',
  'rotate_video_ffmpeg_error': 'FFmpeg execution failed: @error',
  'rotate_video_file_size_calculating': 'Calculating file size...',
  'rotate_video_thumbnail_warning_title': 'Important Notice',

  // Format Descriptions
  'format_webp_description': 'Animated WebP → treated as video',
  'format_mp4_description': 'H.264/H.265, AAC/MP3/Opus audio combinations',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 etc.',
  'format_avi_description': 'MPEG-4 Part 2, MP3, etc.',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 etc.',

  // Loading & Conversion
  'converting': 'Converting...',
  'progress_estimate':
      'The progress bar is an estimate. Actual conversion speed may vary.',
  'still_working': 'Still working hard on your video! 🚀',
  'keep_app_open': 'Please keep the app open for smooth conversion! 🎬',
  'preparing_conversion': 'Preparing conversion...',
  'no_video_selected': 'No video file selected',
  'starting_conversion': 'Starting conversion...',
  'converting_to_format':
      'Converting to @format (Quality: @quality%, FPS: @fps)...',
  'saving_to_gallery': 'Saving to gallery...',
  'conversion_completed_saved': 'Conversion completed and saved to gallery!',
  'conversion_completed_not_saved':
      'Conversion completed but failed to save to gallery',
  'conversion_completed_gallery_failed':
      'Conversion completed but gallery save failed: @error',
  'conversion_failed': 'Conversion failed',
  'conversion_cancelled': 'Conversion cancelled',
  'conversion_error': 'Conversion error: @error',

  // Error Messages
  'error_ffmpeg_not_available':
      'Video processing is not available on this device',
  'error_rotation_filter_not_supported':
      'This device does not support video rotation filters',
  'error_format_not_supported':
      'This device does not support the selected format',
  'error_memory_insufficient': 'Insufficient memory for video conversion',
  'error_rotation_general': 'An error occurred while rotating video: @error',
  'error_conversion_general':
      'An error occurred during video conversion: @error',

  // Convert Result
  'conversion_complete': 'Conversion Complete',
  'conversion_complete_title': 'Conversion Complete!',
  'no_converted_file': 'No converted file found',
  'video_saved_to_gallery': 'Video saved to gallery',
  'file_ready_for_download': 'File ready for download',
  'format_webp': 'Format: WebP',
  'saved_to_gallery': 'Saved to Gallery',
  'not_saved_to_gallery': 'Not saved to Gallery',
  'gallery_save_success_message':
      'Your converted video is now available in your gallery',
  'gallery_save_failed_message':
      'Failed to save to gallery. Check file permissions.',
  'convert_another': 'Convert Another',
  'view_in_gallery': 'View in Gallery',
  'unknown': 'Unknown',
  'gallery_app_not_found':
      'Gallery app not found. Please check your gallery manually.',

  // Notifications
  'notification_conversion_complete_title': '🎬 Video Conversion Complete!',
  'notification_conversion_complete_message':
      '@fileName has been successfully converted to @format and saved to your gallery.',
  'notification_conversion_error_title': '❌ Conversion Failed',
  'notification_conversion_error_message':
      'Video conversion failed: @errorMessage',
};
