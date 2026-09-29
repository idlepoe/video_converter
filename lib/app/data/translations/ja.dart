const Map<String, String> jaTranslations = {
  // App Basic
  'video_converter': 'ビデオコンバーター',
  'select_video': 'ビデオを選択',
  'selected_video_count': '@count本の動画を選択',
  'select_video_file': 'ビデオファイルを選択',
  'tap_to_select_video': 'ビデオを選択するにはタップしてください',
  'convert': '変換',
  'convert_video_count': '@count本の動画を変換',
  'cancel': 'キャンセル',
  'go_back': '戻る',
  'press_back_again_to_exit': 'もう一度戻るを押すと終了します',
  'other_video': '他のビデオ',

  // Video Settings
  'fps': 'FPS',
  'quality': '品質',
  'resolution': '解像度',
  'playback_speed': '再生速度',
  'convert_options': '変換オプション',
  'output_format': '出力形式',

  // Privacy & Consent
  'privacy_protection': 'プライバシー保護',
  'privacy_protection_message': 'ビデオファイルはローカルで処理され、外部サーバーにアップロードされることはありません。',
  'file_deletion_info': 'ファイルはローカルで処理され、変換後に安全に削除できます。',

  // Video Information
  'file_name_label': 'ファイル名:',
  'video_resolution_label': '解像度:',
  'video_duration_label': '時間:',
  'file_size_label': 'ファイルサイズ:',
  'original_file_size': '元のファイルサイズ: @size',

  // Video Actions
  'video_rotate': 'ビデオ回転',
  'video_trim': 'ビデオトリム',

  // Video Trim
  'start_time': '開始時間',
  'end_time': '終了時間',
  'processing': '処理中...',
  'complete_video_trim': 'ビデオトリム完了',
  'trim_error_message': 'ビデオのトリムに失敗しました。再試行してください。',
  'complete': '完了',

  // Video Rotate
  'rotate_angle_selection': '回転角度選択',
  'rotate_video_initializing': '初期化中...',
  'rotate_video_preparing_ffmpeg': 'FFmpegコマンドを準備中...',
  'rotate_video_processing_ffmpeg': 'ビデオ回転を処理中...',
  'rotate_video_checking_result': '結果を確認中...',
  'rotate_video_complete_status': '完了！',
  'rotate_video_processing_status': '処理中...',
  'rotate_video_thumbnail_warning_line1': '• 画面でビデオを回転する際に見える解像度の歪みはUI表示の問題です',
  'rotate_video_thumbnail_warning_line2': '• 実際には、元のビデオの解像度と品質が維持されています',
  'rotate_video_thumbnail_warning_line3': '• FFmpegで処理された最終ファイルは、元と同じ品質で回転されます',
  'rotate_video_processing': 'ビデオを回転中...',
  'rotate_video_complete': 'ビデオが@angle°回転されました。',
  'rotate_video_error': 'ビデオの回転中にエラーが発生しました: @error',
  'rotate_video_file_not_created': '回転されたファイルが作成されませんでした。',
  'rotate_video_rotate_angle': '@angle°',
  'rotate_90_degrees': '90°',
  'rotate_180_degrees': '180°',
  'rotate_270_degrees': '270°',
  'rotate_video_unsupported_angle': 'サポートされていない回転角度: @angle',
  'rotate_video_ffmpeg_error': 'FFmpeg実行失敗: @error',
  'rotate_video_file_size_calculating': 'ファイルサイズを計算中...',
  'rotate_video_thumbnail_warning_title': '重要な注意事項',

  // Format Descriptions
  'format_webp_description': 'アニメーションWebP → 動画として扱う',
  'format_mp4_description': 'H.264/H.265、AAC/MP3/Opusオーディオ組み合わせ',
  'format_mkv_description': 'H.264/H.265/VP9、Opus/Vorbis/MP3など',
  'format_avi_description': 'MPEG-4 Part 2、MP3など',
  'format_flv_description': 'H.264 + MP3/AAC',
  'format_mov_description': 'QuickTime、H.264、AAC、MP3など',

  // Loading & Conversion
  'converting': '変換中...',
  'progress_estimate': 'プログレスバーは推定値です。実際の変換速度は異なる場合があります。',
  'still_working': 'あなたのビデオでまだ頑張って作業中です！ 🚀',
  'keep_app_open': 'スムーズな変換のためにアプリを開いたままにしてください！🎬',
  'preparing_conversion': '変換を準備中...',
  'no_video_selected': 'ビデオファイルが選択されていません',
  'starting_conversion': '変換を開始中...',
  'converting_to_format': '@formatに変換中（品質: @quality%、FPS: @fps）...',
  'saving_to_gallery': 'ギャラリーに保存中...',
  'conversion_completed_saved': '変換完了、ギャラリーに保存されました！',
  'conversion_completed_not_saved': '変換完了しましたが、ギャラリーへの保存に失敗しました',
  'conversion_completed_gallery_failed': '変換完了しましたが、ギャラリー保存に失敗しました: @error',
  'conversion_failed': '変換に失敗しました',
  'conversion_error': '変換エラー: @error',

  // Error Messages
  'error_ffmpeg_not_available': 'このデバイスでは動画処理機能を使用できません',
  'error_rotation_filter_not_supported': 'このデバイスは動画回転フィルターをサポートしていません',
  'error_format_not_supported': 'このデバイスは選択されたフォーマットをサポートしていません',
  'error_memory_insufficient': '動画変換にメモリが不足しています',
  'error_rotation_general': '動画回転中にエラーが発生しました: @error',
  'error_conversion_general': '動画変換中にエラーが発生しました: @error',

  // Convert Result
  'conversion_complete': '変換完了',
  'conversion_complete_title': '変換完了！',
  'no_converted_file': '変換されたファイルが見つかりません',
  'video_saved_to_gallery': 'ビデオがギャラリーに保存されました',
  'file_ready_for_download': 'ファイルのダウンロード準備完了',
  'format_webp': '形式: WebP',
  'saved_to_gallery': 'ギャラリーに保存済み',
  'not_saved_to_gallery': 'ギャラリーに保存されていません',
  'gallery_save_success_message': '変換されたビデオがギャラリーで利用可能になりました',
  'gallery_save_failed_message': 'ギャラリーへの保存に失敗しました。ファイルの権限を確認してください。',
  'convert_another': '別のビデオを変換',
  'view_in_gallery': 'ギャラリーで表示',
  'unknown': '不明',
  'gallery_app_not_found': 'ギャラリーアプリが見つかりません。手動でギャラリーを確認してください。',

  // Notifications
  'notification_conversion_complete_title': '🎬 ビデオ変換完了！',
  'notification_conversion_complete_message':
      '@fileNameが@formatに正常に変換され、ギャラリーに保存されました。',
  'notification_conversion_error_title': '❌ 変換失敗',
  'notification_conversion_error_message': 'ビデオ変換に失敗しました: @errorMessage',
};
