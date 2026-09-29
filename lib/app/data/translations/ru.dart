const Map<String, String> ruTranslations = {
  // App Basic
  'video_converter': 'Конвертер Видео',
  'select_video': 'Выбрать Видео',
  'selected_video_count': 'Выбрано видео: @count',
  'select_video_file': 'Выбрать Видео Файл',
  'tap_to_select_video': 'Нажмите, чтобы выбрать видео',
  'convert': 'Конвертировать',
  'convert_video_count': 'Конвертировать видео: @count',
  'cancel': 'Отмена',
  'go_back': 'Назад',
  'press_back_again_to_exit': 'Нажмите назад ещё раз для выхода',
  'other_video': 'Другое Видео',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Качество',
  'resolution': 'Разрешение',
  'playback_speed': 'Скорость Воспроизведения',
  'convert_options': 'Опции Конвертации',
  'output_format': 'Формат Вывода',

  // Privacy & Consent
  'privacy_protection': 'Защита Конфиденциальности',
  'privacy_protection_message':
      'Ваши видео файлы обрабатываются локально и никогда не загружаются на внешние серверы.',
  'file_deletion_info':
      'Файлы обрабатываются локально и могут быть безопасно удалены после конвертации.',

  // Video Information
  'file_name_label': 'Имя Файла:',
  'video_resolution_label': 'Разрешение:',
  'video_duration_label': 'Продолжительность:',
  'file_size_label': 'Размер Файла:',
  'original_file_size': 'Размер Оригинального Файла: @size',

  // Video Actions
  'video_rotate': 'Повернуть Видео',
  'video_trim': 'Обрезать Видео',

  // Video Trim
  'start_time': 'Время Начала',
  'end_time': 'Время Окончания',
  'processing': 'Обработка...',
  'complete_video_trim': 'Обрезка Видео Завершена',
  'trim_error_message': 'Не удалось обрезать видео. Попробуйте еще раз.',
  'complete': 'Завершено',

  // Video Rotate
  'rotate_angle_selection': 'Выбор Угла Поворота',
  'rotate_video_initializing': 'Инициализация...',
  'rotate_video_preparing_ffmpeg': 'Подготовка команды FFmpeg...',
  'rotate_video_processing_ffmpeg': 'Обработка поворота видео...',
  'rotate_video_checking_result': 'Проверка результата...',
  'rotate_video_complete_status': 'Завершено!',
  'rotate_video_processing_status': 'Обработка...',
  'rotate_video_thumbnail_warning_line1':
      '• Искажение разрешения, которое вы видите при повороте видео на экране, является проблемой отображения UI',
  'rotate_video_thumbnail_warning_line2':
      '• На самом деле, оригинальное разрешение и качество видео сохраняются',
  'rotate_video_thumbnail_warning_line3':
      '• Финальный файл, обработанный FFmpeg, поворачивается с тем же качеством, что и оригинал',
  'rotate_video_processing': 'Поворот видео...',
  'rotate_video_complete': 'Видео повернуто на @angle°.',
  'rotate_video_error': 'Произошла ошибка при повороте видео: @error',
  'rotate_video_file_not_created': 'Повернутый файл не был создан.',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'Неподдерживаемый угол поворота: @angle',
  'rotate_video_ffmpeg_error': 'Выполнение FFmpeg не удалось: @error',
  'rotate_video_file_size_calculating': 'Вычисление размера файла...',
  'rotate_video_thumbnail_warning_title': 'Важное уведомление',

  // Format Descriptions
  'format_webp_description': 'Анимированный WebP → обрабатывается как видео',
  'format_mp4_description': 'H.264/H.265, аудио комбинации AAC/MP3/Opus',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 и др.',
  'format_avi_description': 'MPEG-4 Part 2, MP3, и др.',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 и др.',

  // Loading & Conversion
  'converting': 'Конвертация...',
  'progress_estimate':
      'Полоса прогресса является приблизительной. Фактическая скорость конвертации может варьироваться.',
  'still_working': 'Все еще усердно работаем над вашим видео! 🚀',
  'keep_app_open':
      'Пожалуйста, держите приложение открытым для плавной конвертации! 🎬',
  'preparing_conversion': 'Подготовка конвертации...',
  'no_video_selected': 'Видео файл не выбран',
  'starting_conversion': 'Запуск конвертации...',
  'converting_to_format':
      'Конвертация в @format (Качество: @quality%, FPS: @fps)...',
  'saving_to_gallery': 'Сохранение в галерею...',
  'conversion_completed_saved': 'Конвертация завершена и сохранена в галерею!',
  'conversion_completed_not_saved':
      'Конвертация завершена, но не удалось сохранить в галерею',
  'conversion_completed_gallery_failed':
      'Конвертация завершена, но сохранение в галерею не удалось: @error',
  'conversion_failed': 'Конвертация не удалась',
  'conversion_error': 'Ошибка конвертации: @error',

  // Error Messages
  'error_ffmpeg_not_available': 'Обработка видео недоступна на этом устройстве',
  'error_rotation_filter_not_supported':
      'Это устройство не поддерживает фильтры поворота видео',
  'error_format_not_supported':
      'Это устройство не поддерживает выбранный формат',
  'error_memory_insufficient': 'Недостаточно памяти для конвертации видео',
  'error_rotation_general': 'Произошла ошибка при повороте видео: @error',
  'error_conversion_general': 'Произошла ошибка при конвертации видео: @error',

  // Convert Result
  'conversion_complete': 'Конвертация Завершена',
  'conversion_complete_title': 'Конвертация Завершена!',
  'no_converted_file': 'Конвертированный файл не найден',
  'video_saved_to_gallery': 'Видео сохранено в галерею',
  'file_ready_for_download': 'Файл готов к загрузке',
  'format_webp': 'Формат: WebP',
  'saved_to_gallery': 'Сохранено в Галерею',
  'not_saved_to_gallery': 'Не Сохранено в Галерею',
  'gallery_save_success_message':
      'Ваше конвертированное видео теперь доступно в галерее',
  'gallery_save_failed_message':
      'Не удалось сохранить в галерею. Проверьте разрешения файла.',
  'convert_another': 'Конвертировать Другое',
  'view_in_gallery': 'Просмотр в Галерее',
  'unknown': 'Неизвестно',
  'gallery_app_not_found':
      'Приложение галереи не найдено. Пожалуйста, проверьте галерею вручную.',

  // Notifications
  'notification_conversion_complete_title': '🎬 Конвертация Видео Завершена!',
  'notification_conversion_complete_message':
      '@fileName был успешно конвертирован в @format и сохранен в вашу галерею.',
  'notification_conversion_error_title': '❌ Конвертация Не Удалась',
  'notification_conversion_error_message':
      'Конвертация видео не удалась: @errorMessage',
};
