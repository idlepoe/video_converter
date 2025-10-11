const Map<String, String> esTranslations = {
  // App Basic
  'video_converter': 'Convertidor de Video',
  'select_video': 'Seleccionar Video',
  'select_video_file': 'Seleccionar Archivo de Video',
  'tap_to_select_video': 'Toca para seleccionar un video',
  'convert': 'Convertir',
  'cancel': 'Cancelar',
  'other_video': 'Otro Video',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Calidad',
  'resolution': 'Resolución',
  'playback_speed': 'Velocidad de Reproducción',
  'convert_options': 'Opciones de Conversión',
  'output_format': 'Formato de Salida',

  // Privacy & Consent
  'privacy_protection': 'Protección de Privacidad',
  'privacy_protection_message':
      'Tus archivos de video se procesan localmente y nunca se suben a servidores externos.',
  'file_deletion_info':
      'Los archivos se procesan localmente y se pueden eliminar de forma segura después de la conversión.',

  // Video Information
  'file_name_label': 'Nombre del Archivo:',
  'video_resolution_label': 'Resolución:',
  'video_duration_label': 'Duración:',
  'file_size_label': 'Tamaño del Archivo:',
  'original_file_size': 'Tamaño del Archivo Original: @size',

  // Video Actions
  'video_rotate': 'Rotar Video',
  'video_trim': 'Recortar Video',

  // Video Trim
  'start_time': 'Tiempo de Inicio',
  'end_time': 'Tiempo de Finalización',
  'processing': 'Procesando...',
  'complete_video_trim': 'Recorte de Video Completo',
  'trim_error_message': 'Error al recortar el video. Inténtalo de nuevo.',
  'complete': 'Completo',

  // Video Rotate
  'rotate_angle_selection': 'Selección de Ángulo de Rotación',
  'rotate_video_initializing': 'Inicializando...',
  'rotate_video_preparing_ffmpeg': 'Preparando comando FFmpeg...',
  'rotate_video_processing_ffmpeg': 'Procesando rotación de video...',
  'rotate_video_checking_result': 'Verificando resultado...',
  'rotate_video_complete_status': '¡Completo!',
  'rotate_video_processing_status': 'Procesando...',
  'rotate_video_thumbnail_warning_line1':
      '• La distorsión de resolución que ves al rotar video en pantalla es un problema de visualización de UI',
  'rotate_video_thumbnail_warning_line2':
      '• En realidad, se mantiene la resolución y calidad original del video',
  'rotate_video_thumbnail_warning_line3':
      '• El archivo final procesado por FFmpeg se rota con la misma calidad que el original',
  'rotate_video_processing': 'Rotando video...',
  'rotate_video_complete': 'El video ha sido rotado @angle°.',
  'rotate_video_error': 'Ocurrió un error al rotar el video: @error',
  'rotate_video_file_not_created': 'No se creó el archivo rotado.',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'Ángulo de rotación no soportado: @angle',
  'rotate_video_ffmpeg_error': 'Falló la ejecución de FFmpeg: @error',
  'rotate_video_file_size_calculating': 'Calculando tamaño del archivo...',
  'rotate_video_thumbnail_warning_title': 'Aviso Importante',

  // Format Descriptions
  'format_webp_description': 'WebP animado → tratado como video',
  'format_mp4_description': 'H.264/H.265, combinaciones de audio AAC/MP3/Opus',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 etc.',
  'format_avi_description': 'MPEG-4 Part 2, MP3, etc.',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 etc.',

  // Loading & Conversion
  'converting': 'Convirtiendo...',
  'progress_estimate':
      'La barra de progreso es una estimación. La velocidad real de conversión puede variar.',
  'still_working': '¡Seguimos trabajando duro en tu video!',
  'keep_app_open': '¡Mantén la app abierta para una conversión fluida! 🎬',
  'preparing_conversion': 'Preparando conversión...',
  'no_video_selected': 'No se seleccionó archivo de video',
  'starting_conversion': 'Iniciando conversión...',
  'converting_to_format':
      'Convirtiendo a @format (Calidad: @quality%, FPS: @fps)...',
  'saving_to_gallery': 'Guardando en galería...',
  'conversion_completed_saved': '¡Conversión completada y guardada en galería!',
  'conversion_completed_not_saved':
      'Conversión completada pero falló al guardar en galería',
  'conversion_completed_gallery_failed':
      'Conversión completada pero falló al guardar en galería: @error',
  'conversion_failed': 'Conversión falló',
  'conversion_error': 'Error de conversión: @error',

  // Error Messages
  'error_ffmpeg_not_available':
      'El procesamiento de video no está disponible en este dispositivo',
  'error_rotation_filter_not_supported':
      'Este dispositivo no admite filtros de rotación de video',
  'error_format_not_supported':
      'Este dispositivo no admite el formato seleccionado',
  'error_memory_insufficient':
      'Memoria insuficiente para la conversión de video',
  'error_rotation_general': 'Ocurrió un error al rotar el video: @error',
  'error_conversion_general':
      'Ocurrió un error durante la conversión de video: @error',

  // Convert Result
  'conversion_complete': 'Conversión Completa',
  'conversion_complete_title': '¡Conversión Completa!',
  'no_converted_file': 'No se encontró archivo convertido',
  'video_saved_to_gallery': 'Video guardado en galería',
  'file_ready_for_download': 'Archivo listo para descarga',
  'format_webp': 'Formato: WebP',
  'saved_to_gallery': 'Guardado en Galería',
  'not_saved_to_gallery': 'No guardado en Galería',
  'gallery_save_success_message':
      'Tu video convertido ya está disponible en tu galería',
  'gallery_save_failed_message':
      'Falló al guardar en galería. Verifica los permisos del archivo.',
  'convert_another': 'Convertir Otro',
  'view_in_gallery': 'Ver en Galería',
  'unknown': 'Desconocido',
  'gallery_app_not_found':
      'App de galería no encontrada. Verifica tu galería manualmente.',
};
