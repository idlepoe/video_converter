const Map<String, String> koTranslations = {
  // App Basic
  'video_converter': 'WebP 변환기',
  'select_video': '비디오 선택',
  'select_video_file': '비디오 파일 선택',
  'tap_to_select_video': '비디오를 선택하려면 탭하세요',
  'convert': '변환',
  'cancel': '취소',
  'go_back': '뒤로 가기',
  'other_video': '다른 비디오',

  // Video Settings
  'fps': 'FPS',
  'quality': '품질',
  'resolution': '해상도',
  'playback_speed': '재생 속도',
  'convert_options': '변환 옵션',
  'output_format': '출력 형식',

  // Privacy & Consent
  'privacy_protection': '개인정보 보호',
  'privacy_protection_message': '비디오 파일은 로컬에서 처리되며 외부 서버에 업로드되지 않습니다.',
  'file_deletion_info': '파일은 로컬에서 처리되며 변환 후 안전하게 삭제할 수 있습니다.',

  // Video Information
  'file_name_label': '파일명:',
  'video_resolution_label': '해상도:',
  'video_duration_label': '재생 시간:',
  'file_size_label': '파일 크기:',
  'original_file_size': '원본 파일 크기: @size',

  // Video Actions
  'video_rotate': '비디오 회전',
  'video_trim': '비디오 자르기',

  // Video Trim
  'start_time': '시작 시간',
  'end_time': '종료 시간',
  'processing': '처리 중...',
  'complete_video_trim': '비디오 자르기 완료',
  'trim_error_message': '비디오 자르기에 실패했습니다. 다시 시도해주세요.',
  'complete': '완료',

  // Video Rotate
  'rotate_angle_selection': '회전 각도 선택',
  'rotate_video_initializing': '초기화 중...',
  'rotate_video_preparing_ffmpeg': 'FFmpeg 명령어 준비 중...',
  'rotate_video_processing_ffmpeg': '비디오 회전 처리 중...',
  'rotate_video_checking_result': '결과 확인 중...',
  'rotate_video_complete_status': '완료!',
  'rotate_video_processing_status': '처리 중...',
  'rotate_video_thumbnail_warning_line1':
      '• 화면에서 비디오를 회전할 때 보이는 해상도 왜곡은 UI 표시 문제입니다',
  'rotate_video_thumbnail_warning_line2': '• 실제로는 원본 비디오의 해상도와 품질이 유지됩니다',
  'rotate_video_thumbnail_warning_line3':
      '• FFmpeg로 처리된 최종 파일은 원본과 같은 품질로 회전됩니다',
  'rotate_video_processing': '비디오 회전 중...',
  'rotate_video_complete': '비디오가 @angle° 회전되었습니다.',
  'rotate_video_error': '비디오 회전 중 오류가 발생했습니다: @error',
  'rotate_video_file_not_created': '회전된 파일이 생성되지 않았습니다.',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': '지원되지 않는 회전 각도: @angle',
  'rotate_video_ffmpeg_error': 'FFmpeg 실행 실패: @error',
  'rotate_video_file_size_calculating': '파일 크기 계산 중...',
  'rotate_video_thumbnail_warning_title': '중요한 안내',

  // Format Descriptions
  'format_webp_description': '애니메이션 WebP → 영상처럼 다룸',
  'format_mp4_description': 'H.264/H.265, AAC/MP3/Opus 등 오디오 조합',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 등',
  'format_avi_description': 'MPEG-4 Part 2, MP3, etc.',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 등',

  // Loading & Conversion
  'converting': '변환 중...',
  'progress_estimate': '진행률 표시줄은 추정치입니다. 실제 변환 속도는 다를 수 있습니다.',
  'still_working': '비디오를 열심히 변환하고 있습니다! 🚀',
  'keep_app_open': '원활한 변환을 위해 앱을 열어두세요! 🎬',
  'preparing_conversion': '변환 준비 중...',
  'no_video_selected': '비디오 파일이 선택되지 않았습니다',
  'starting_conversion': '변환 시작 중...',
  'converting_to_format': '@format 형식으로 변환 중 (품질: @quality%, FPS: @fps)',
  'saving_to_gallery': '갤러리에 저장 중...',
  'conversion_completed_saved': '변환이 완료되어 갤러리에 저장되었습니다!',
  'conversion_completed_not_saved': '변환은 완료되었지만 갤러리 저장에 실패했습니다',
  'conversion_completed_gallery_failed': '변환은 완료되었지만 갤러리 저장에 실패했습니다: @error',
  'conversion_failed': '변환에 실패했습니다',
  'conversion_cancelled': '변환이 취소되었습니다',
  'conversion_error': '변환 중 오류가 발생했습니다: @error',

  // Error Messages
  'error_ffmpeg_not_available': '이 디바이스에서는 비디오 처리 기능을 사용할 수 없습니다',
  'error_rotation_filter_not_supported': '이 디바이스에서는 비디오 회전 필터를 지원하지 않습니다',
  'error_format_not_supported': '이 디바이스에서는 선택한 포맷을 지원하지 않습니다',
  'error_memory_insufficient': '비디오 변환을 위한 메모리가 부족합니다',
  'error_rotation_general': '비디오 회전 중 오류가 발생했습니다: @error',
  'error_conversion_general': '비디오 변환 중 오류가 발생했습니다: @error',

  // Convert Result
  'conversion_complete': '변환 완료',
  'conversion_complete_title': '변환 완료!',
  'no_converted_file': '변환된 파일을 찾을 수 없습니다',
  'video_saved_to_gallery': '비디오가 갤러리에 저장되었습니다',
  'file_ready_for_download': '파일 다운로드 준비 완료',
  'format_webp': '형식: WebP',
  'saved_to_gallery': '갤러리에 저장됨',
  'not_saved_to_gallery': '갤러리에 저장되지 않음',
  'gallery_save_success_message': '변환된 비디오가 갤러리에서 확인할 수 있습니다',
  'gallery_save_failed_message': '갤러리 저장에 실패했습니다. 파일 권한을 확인해주세요.',
  'convert_another': '다른 비디오 변환',
  'view_in_gallery': '갤러리에서 보기',
  'unknown': '알 수 없음',
  'gallery_app_not_found': '갤러리 앱을 찾을 수 없습니다. 수동으로 갤러리를 확인해주세요.',

  // Notifications
  'notification_conversion_complete_title': '🎬 비디오 변환 완료!',
  'notification_conversion_complete_message':
      '@fileName이 @format 형식으로 성공적으로 변환되어 갤러리에 저장되었습니다.',
  'notification_conversion_error_title': '❌ 변환 실패',
  'notification_conversion_error_message': '비디오 변환 실패: @errorMessage',
};
