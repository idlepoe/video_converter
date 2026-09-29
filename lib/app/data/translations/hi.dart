const Map<String, String> hiTranslations = {
  // App Basic
  'video_converter': 'वीडियो कन्वर्टर',
  'select_video': 'वीडियो चुनें',
  'select_video_file': 'वीडियो फ़ाइल चुनें',
  'tap_to_select_video': 'वीडियो चुनने के लिए टैप करें',
  'convert': 'कन्वर्ट करें',
  'convert_video_count': '@count वीडियो कन्वर्ट करें',
  'cancel': 'रद्द करें',
  'go_back': 'वापस जाएं',
  'press_back_again_to_exit': 'बाहर निकलने के लिए फिर से वापस दबाएं',
  'other_video': 'अन्य वीडियो',

  // Video Settings
  'fps': 'FPS',
  'quality': 'गुणवत्ता',
  'resolution': 'रिज़ॉल्यूशन',
  'playback_speed': 'प्लेबैक गति',
  'convert_options': 'कन्वर्ज़न विकल्प',
  'output_format': 'आउटपुट प्रारूप',

  // Privacy & Consent
  'privacy_protection': 'गोपनीयता सुरक्षा',
  'privacy_protection_message':
      'आपकी वीडियो फ़ाइलें स्थानीय रूप से प्रोसेस की जाती हैं और कभी भी बाहरी सर्वर पर अपलोड नहीं की जातीं।',
  'file_deletion_info':
      'फ़ाइलें स्थानीय रूप से प्रोसेस की जाती हैं और कन्वर्ज़न के बाद सुरक्षित रूप से हटाई जा सकती हैं।',

  // Video Information
  'file_name_label': 'फ़ाइल नाम:',
  'video_resolution_label': 'रिज़ॉल्यूशन:',
  'video_duration_label': 'अवधि:',
  'file_size_label': 'फ़ाइल आकार:',
  'original_file_size': 'मूल फ़ाइल आकार: @size',

  // Video Actions
  'video_rotate': 'वीडियो घुमाएं',
  'video_trim': 'वीडियो ट्रिम करें',

  // Video Trim
  'start_time': 'शुरुआती समय',
  'end_time': 'अंतिम समय',
  'processing': 'प्रोसेसिंग...',
  'complete_video_trim': 'वीडियो ट्रिम पूर्ण',
  'trim_error_message': 'वीडियो ट्रिम करने में विफल। कृपया पुनः प्रयास करें।',
  'complete': 'पूर्ण',

  // Video Rotate
  'rotate_angle_selection': 'रोटेशन कोण चयन',
  'rotate_video_initializing': 'आरंभ कर रहे हैं...',
  'rotate_video_preparing_ffmpeg': 'FFmpeg कमांड तैयार कर रहे हैं...',
  'rotate_video_processing_ffmpeg': 'वीडियो रोटेशन प्रोसेसिंग...',
  'rotate_video_checking_result': 'परिणाम जांच रहे हैं...',
  'rotate_video_complete_status': 'पूर्ण!',
  'rotate_video_processing_status': 'प्रोसेसिंग...',
  'rotate_video_thumbnail_warning_line1':
      '• स्क्रीन पर वीडियो रोटेट करते समय जो रिज़ॉल्यूशन विकृति दिखती है वह UI डिस्प्ले समस्या है',
  'rotate_video_thumbnail_warning_line2':
      '• वास्तव में, मूल वीडियो रिज़ॉल्यूशन और गुणवत्ता बनाए रखी जाती है',
  'rotate_video_thumbnail_warning_line3':
      '• FFmpeg द्वारा प्रोसेस की गई अंतिम फ़ाइल मूल के समान गुणवत्ता के साथ रोटेट होती है',
  'rotate_video_processing': 'वीडियो रोटेट कर रहे हैं...',
  'rotate_video_complete': 'वीडियो @angle° घुमाया गया है।',
  'rotate_video_error': 'वीडियो रोटेट करते समय त्रुटि हुई: @error',
  'rotate_video_file_not_created': 'रोटेटेड फ़ाइल नहीं बनाई गई।',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'असमर्थित रोटेशन कोण: @angle',
  'rotate_video_ffmpeg_error': 'FFmpeg निष्पादन विफल: @error',
  'rotate_video_file_size_calculating': 'फ़ाइल आकार की गणना...',
  'rotate_video_thumbnail_warning_title': 'महत्वपूर्ण सूचना',

  // Format Descriptions
  'format_webp_description': 'एनिमेटेड WebP → वीडियो के रूप में माना जाता है',
  'format_mp4_description': 'H.264/H.265, AAC/MP3/Opus ऑडियो संयोजन',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 आदि',
  'format_avi_description': 'MPEG-4 Part 2, MP3, आदि',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 आदि',

  // Loading & Conversion
  'converting': 'कन्वर्ट कर रहे हैं...',
  'progress_estimate':
      'प्रगति बार एक अनुमान है। वास्तविक कन्वर्ज़न गति भिन्न हो सकती है।',
  'still_working': 'अभी भी आपके वीडियो पर कड़ी मेहनत कर रहे हैं! 🚀',
  'keep_app_open': 'सुचारू कन्वर्ज़न के लिए कृपया ऐप खुला रखें! 🎬',
  'preparing_conversion': 'कन्वर्ज़न तैयार कर रहे हैं...',
  'no_video_selected': 'कोई वीडियो फ़ाइल नहीं चुनी गई',
  'starting_conversion': 'कन्वर्ज़न शुरू कर रहे हैं...',
  'converting_to_format':
      '@format में कन्वर्ट कर रहे हैं (गुणवत्ता: @quality%, FPS: @fps)...',
  'saving_to_gallery': 'गैलरी में सहेज रहे हैं...',
  'conversion_completed_saved': 'कन्वर्ज़न पूर्ण और गैलरी में सहेजा गया!',
  'conversion_completed_not_saved':
      'कन्वर्ज़न पूर्ण लेकिन गैलरी में सहेजने में विफल',
  'conversion_completed_gallery_failed':
      'कन्वर्ज़न पूर्ण लेकिन गैलरी सेव विफल: @error',
  'conversion_failed': 'कन्वर्ज़न विफल',
  'conversion_error': 'कन्वर्ज़न त्रुटि: @error',

  // Error Messages
  'error_ffmpeg_not_available': 'इस डिवाइस पर वीडियो प्रोसेसिंग उपलब्ध नहीं है',
  'error_rotation_filter_not_supported':
      'यह डिवाइस वीडियो रोटेशन फिल्टर का समर्थन नहीं करता',
  'error_format_not_supported': 'यह डिवाइस चयनित प्रारूप का समर्थन नहीं करता',
  'error_memory_insufficient': 'वीडियो रूपांतरण के लिए अपर्याप्त मेमोरी',
  'error_rotation_general': 'वीडियो घुमाते समय त्रुटि हुई: @error',
  'error_conversion_general': 'वीडियो रूपांतरण के दौरान त्रुटि हुई: @error',

  // Convert Result
  'conversion_complete': 'कन्वर्ज़न पूर्ण',
  'conversion_complete_title': 'कन्वर्ज़न पूर्ण!',
  'no_converted_file': 'कोई कन्वर्टेड फ़ाइल नहीं मिली',
  'video_saved_to_gallery': 'वीडियो गैलरी में सहेजा गया',
  'file_ready_for_download': 'फ़ाइल डाउनलोड के लिए तैयार',
  'format_webp': 'प्रारूप: WebP',
  'saved_to_gallery': 'गैलरी में सहेजा गया',
  'not_saved_to_gallery': 'गैलरी में नहीं सहेजा गया',
  'gallery_save_success_message':
      'आपका कन्वर्टेड वीडियो अब आपकी गैलरी में उपलब्ध है',
  'gallery_save_failed_message':
      'गैलरी में सहेजने में विफल। फ़ाइल अनुमतियों की जांच करें।',
  'convert_another': 'अन्य कन्वर्ट करें',
  'view_in_gallery': 'गैलरी में देखें',
  'unknown': 'अज्ञात',
  'gallery_app_not_found':
      'गैलरी ऐप नहीं मिला। कृपया अपनी गैलरी को मैन्युअल रूप से जांचें।',

  // Notifications
  'notification_conversion_complete_title': '🎬 वीडियो रूपांतरण पूर्ण!',
  'notification_conversion_complete_message':
      '@fileName को सफलतापूर्वक @format में रूपांतरित किया गया और आपकी गैलरी में सहेजा गया।',
  'notification_conversion_error_title': '❌ रूपांतरण विफल',
  'notification_conversion_error_message':
      'वीडियो रूपांतरण विफल: @errorMessage',
};
