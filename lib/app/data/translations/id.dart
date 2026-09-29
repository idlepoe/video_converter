const Map<String, String> idTranslations = {
  // App Basic
  'video_converter': 'Konverter Video',
  'select_video': 'Pilih Video',
  'selected_video_count': '@count video dipilih',
  'select_video_file': 'Pilih File Video',
  'tap_to_select_video': 'Ketuk untuk memilih video',
  'convert': 'Konversi',
  'convert_video_count': 'Konversi @count video',
  'cancel': 'Batal',
  'go_back': 'Kembali',
  'press_back_again_to_exit': 'Tekan kembali sekali lagi untuk keluar',
  'other_video': 'Video Lain',

  // Video Settings
  'fps': 'FPS',
  'quality': 'Kualitas',
  'resolution': 'Resolusi',
  'playback_speed': 'Kecepatan Pemutaran',
  'convert_options': 'Opsi Konversi',
  'output_format': 'Format Output',

  // Privacy & Consent
  'privacy_protection': 'Perlindungan Privasi',
  'privacy_protection_message':
      'File video Anda diproses secara lokal dan tidak pernah diunggah ke server eksternal.',
  'file_deletion_info':
      'File diproses secara lokal dan dapat dihapus dengan aman setelah konversi.',

  // Video Information
  'file_name_label': 'Nama File:',
  'video_resolution_label': 'Resolusi:',
  'video_duration_label': 'Durasi:',
  'file_size_label': 'Ukuran File:',
  'original_file_size': 'Ukuran File Asli: @size',

  // Video Actions
  'video_rotate': 'Putar Video',
  'video_trim': 'Potong Video',

  // Video Trim
  'start_time': 'Waktu Mulai',
  'end_time': 'Waktu Selesai',
  'processing': 'Memproses...',
  'complete_video_trim': 'Pemotongan Video Selesai',
  'trim_error_message': 'Gagal memotong video. Silakan coba lagi.',
  'complete': 'Selesai',

  // Video Rotate
  'rotate_angle_selection': 'Pemilihan Sudut Rotasi',
  'rotate_video_initializing': 'Menginisialisasi...',
  'rotate_video_preparing_ffmpeg': 'Mempersiapkan perintah FFmpeg...',
  'rotate_video_processing_ffmpeg': 'Memproses rotasi video...',
  'rotate_video_checking_result': 'Memeriksa hasil...',
  'rotate_video_complete_status': 'Selesai!',
  'rotate_video_processing_status': 'Memproses...',
  'rotate_video_thumbnail_warning_line1':
      '• Distorsi resolusi yang Anda lihat saat memutar video di layar adalah masalah tampilan UI',
  'rotate_video_thumbnail_warning_line2':
      '• Sebenarnya, resolusi dan kualitas video asli dipertahankan',
  'rotate_video_thumbnail_warning_line3':
      '• File akhir yang diproses oleh FFmpeg diputar dengan kualitas yang sama dengan aslinya',
  'rotate_video_processing': 'Memutar video...',
  'rotate_video_complete': 'Video telah diputar @angle°.',
  'rotate_video_error': 'Terjadi kesalahan saat memutar video: @error',
  'rotate_video_file_not_created': 'File yang diputar tidak dibuat.',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'Sudut rotasi tidak didukung: @angle',
  'rotate_video_ffmpeg_error': 'Eksekusi FFmpeg gagal: @error',
  'rotate_video_file_size_calculating': 'Menghitung ukuran file...',
  'rotate_video_thumbnail_warning_title': 'Pemberitahuan Penting',

  // Format Descriptions
  'format_webp_description': 'WebP animasi → diperlakukan sebagai video',
  'format_mp4_description': 'H.264/H.265, kombinasi audio AAC/MP3/Opus',
  'format_mkv_description': 'H.264/H.265/VP9, Opus/Vorbis/MP3 dll.',
  'format_avi_description': 'MPEG-4 Part 2, MP3, dll.',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime, H.264, AAC, MP3 dll.',

  // Loading & Conversion
  'converting': 'Mengkonversi...',
  'progress_estimate':
      'Bar kemajuan adalah perkiraan. Kecepatan konversi aktual dapat bervariasi.',
  'still_working': 'Masih bekerja keras pada video Anda! 🚀',
  'keep_app_open':
      'Tolong jaga aplikasi tetap terbuka untuk konversi yang lancar! 🎬',
  'preparing_conversion': 'Mempersiapkan konversi...',
  'no_video_selected': 'Tidak ada file video yang dipilih',
  'starting_conversion': 'Memulai konversi...',
  'converting_to_format':
      'Mengkonversi ke @format (Kualitas: @quality%, FPS: @fps)...',
  'saving_to_gallery': 'Menyimpan ke galeri...',
  'conversion_completed_saved': 'Konversi selesai dan disimpan ke galeri!',
  'conversion_completed_not_saved':
      'Konversi selesai tetapi gagal menyimpan ke galeri',
  'conversion_completed_gallery_failed':
      'Konversi selesai tetapi penyimpanan galeri gagal: @error',
  'conversion_failed': 'Konversi gagal',
  'conversion_error': 'Kesalahan konversi: @error',

  // Error Messages
  'error_ffmpeg_not_available':
      'Pemrosesan video tidak tersedia di perangkat ini',
  'error_rotation_filter_not_supported':
      'Perangkat ini tidak mendukung filter rotasi video',
  'error_format_not_supported':
      'Perangkat ini tidak mendukung format yang dipilih',
  'error_memory_insufficient': 'Memori tidak cukup untuk konversi video',
  'error_rotation_general': 'Terjadi kesalahan saat memutar video: @error',
  'error_conversion_general': 'Terjadi kesalahan selama konversi video: @error',

  // Convert Result
  'conversion_complete': 'Konversi Selesai',
  'conversion_complete_title': 'Konversi Selesai!',
  'no_converted_file': 'Tidak ada file yang dikonversi ditemukan',
  'video_saved_to_gallery': 'Video disimpan ke galeri',
  'file_ready_for_download': 'File siap untuk diunduh',
  'format_webp': 'Format: WebP',
  'saved_to_gallery': 'Disimpan ke Galeri',
  'not_saved_to_gallery': 'Tidak Disimpan ke Galeri',
  'gallery_save_success_message':
      'Video yang dikonversi Anda sekarang tersedia di galeri Anda',
  'gallery_save_failed_message':
      'Gagal menyimpan ke galeri. Periksa izin file.',
  'convert_another': 'Konversi Lain',
  'view_in_gallery': 'Lihat di Galeri',
  'unknown': 'Tidak Diketahui',
  'gallery_app_not_found':
      'Aplikasi galeri tidak ditemukan. Silakan periksa galeri Anda secara manual.',

  // Notifications
  'notification_conversion_complete_title': '🎬 Konversi Video Selesai!',
  'notification_conversion_complete_message':
      '@fileName telah berhasil dikonversi ke @format dan disimpan ke galeri Anda.',
  'notification_conversion_error_title': '❌ Konversi Gagal',
  'notification_conversion_error_message':
      'Konversi video gagal: @errorMessage',
};
