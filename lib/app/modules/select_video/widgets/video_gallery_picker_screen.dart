import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoGalleryPickerScreen extends StatefulWidget {
  const VideoGalleryPickerScreen({super.key});

  @override
  State<VideoGalleryPickerScreen> createState() =>
      _VideoGalleryPickerScreenState();
}

class _VideoGalleryPickerScreenState extends State<VideoGalleryPickerScreen>
    with WidgetsBindingObserver {
  final _selectedIds = <String>{};
  final _thumbnailController = ScrollController();
  late final PageController _pageController;

  List<AssetEntity> _assets = const [];
  bool _loading = true;
  bool _permissionDenied = false;
  bool _appActive = true;
  int _playbackCount = 1;
  int _gridColumns = 2;
  int _currentGroup = 0;

  int get _groupCount =>
      _assets.isEmpty ? 0 : (_assets.length / _playbackCount).ceil();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    _initialize();
  }

  Future<void> _initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final savedPlayback = preferences.getInt('gallery_max_playing_videos') ?? 1;
    final allowedPlayback = [1, 2, 4, 6, 8, 10, 12];
    _playbackCount = allowedPlayback.contains(savedPlayback)
        ? savedPlayback
        : 4;
    _gridColumns = (preferences.getInt('gallery_grid_columns') ?? 2).clamp(
      1,
      6,
    );
    await _loadVideos();
  }

  Future<void> _loadVideos() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.hasAccess) {
      if (mounted) {
        setState(() {
          _loading = false;
          _permissionDenied = true;
        });
      }
      return;
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );
    final videos = albums.isEmpty
        ? <AssetEntity>[]
        : await albums.first.getAssetListPaged(page: 0, size: 500);
    if (!mounted) return;
    setState(() {
      _assets = videos;
      _loading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final active = state == AppLifecycleState.resumed;
    if (mounted && active != _appActive) setState(() => _appActive = active);
  }

  List<AssetEntity> _assetsForGroup(int group) {
    final start = group * _playbackCount;
    if (start >= _assets.length) return const [];
    return _assets.sublist(
      start,
      math.min(start + _playbackCount, _assets.length),
    );
  }

  void _navigateToAsset(int index) {
    final targetGroup = index ~/ _playbackCount;
    _pageController.animateToPage(
      targetGroup,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (!_selectedIds.remove(asset.id)) _selectedIds.add(asset.id);
    });
  }

  Future<void> _changePlaybackCount(int value) async {
    final anchorIndex = _currentGroup * _playbackCount;
    final targetGroup = anchorIndex ~/ value;
    setState(() {
      _playbackCount = value;
      _currentGroup = targetGroup.clamp(0, math.max(0, _groupCount - 1));
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('gallery_max_playing_videos', value);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentGroup);
      }
    });
  }

  Future<void> _changeGridColumns(int value) async {
    setState(() => _gridColumns = value);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('gallery_grid_columns', value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _groupCount == 0
              ? 'Videos (${_selectedIds.length})'
              : 'Group ${_currentGroup + 1}/$_groupCount · ${_selectedIds.length} selected',
        ),
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.tune),
            tooltip: 'Playback layout',
          ),
          TextButton(
            onPressed: _selectedIds.isEmpty
                ? null
                : () => Navigator.pop(
                    context,
                    _assets
                        .where((asset) => _selectedIds.contains(asset.id))
                        .toList(),
                  ),
            child: const Text('Done'),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.video_library_outlined,
              color: Colors.white70,
              size: 52,
            ),
            const SizedBox(height: 12),
            const Text(
              'Video access is required',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: PhotoManager.openSetting,
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
    if (_assets.isEmpty) {
      return const Center(
        child: Text('No videos found', style: TextStyle(color: Colors.white)),
      );
    }
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: _groupCount,
            onPageChanged: (group) {
              setState(() => _currentGroup = group);
              _scrollThumbnailToGroup(group);
            },
            itemBuilder: (_, group) => _PlayingVideoGrid(
              key: ValueKey('group_${group}_${_playbackCount}_$_gridColumns'),
              assets: _assetsForGroup(group),
              columns: _gridColumns,
              active: _appActive && group == _currentGroup,
              selectedIds: _selectedIds,
              onToggleSelection: _toggleSelection,
            ),
          ),
        ),
        _buildGroupIndicator(),
        _buildThumbnailNavigation(),
      ],
    );
  }

  Widget _buildGroupIndicator() {
    return Container(
      color: const Color(0xFF161616),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        children: [
          const Icon(Icons.swipe_vertical, color: Colors.white54, size: 17),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Swipe vertically or tap a thumbnail to change the group',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            '$_playbackCount playing',
            style: const TextStyle(color: Color(0xFF64A8FF), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailNavigation() {
    final groupStart = _currentGroup * _playbackCount;
    final groupEnd = math.min(groupStart + _playbackCount, _assets.length);
    return Container(
      height: 92,
      color: const Color(0xFF0C0C0C),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        controller: _thumbnailController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _assets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, index) {
          final asset = _assets[index];
          return _VideoNavigationThumbnail(
            asset: asset,
            inPlayingGroup: index >= groupStart && index < groupEnd,
            selected: _selectedIds.contains(asset.id),
            selectionNumber: _selectedIds.toList().indexOf(asset.id) + 1,
            onNavigate: () => _navigateToAsset(index),
            onToggleSelection: () => _toggleSelection(asset),
          );
        },
      ),
    );
  }

  void _scrollThumbnailToGroup(int group) {
    if (!_thumbnailController.hasClients) return;
    final target = group * _playbackCount * 70.0;
    _thumbnailController.animateTo(
      target.clamp(0, _thumbnailController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _showSettings() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simultaneous playback',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [1, 2, 4, 6, 8, 10, 12]
                    .map(
                      (count) => ChoiceChip(
                        label: Text('$count'),
                        selected: _playbackCount == count,
                        onSelected: (_) {
                          _changePlaybackCount(count);
                          setSheetState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              Text(
                'Playback grid columns: $_gridColumns',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _gridColumns.toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                label: '$_gridColumns',
                onChanged: (value) {
                  _changeGridColumns(value.round());
                  setSheetState(() {});
                },
              ),
              const Text(
                'Only the current group creates video players. Bottom thumbnails remain static.',
                style: TextStyle(color: Color(0xFF6B7684), fontSize: 12),
              ),
              const SizedBox(height: 6),
              const Text(
                'Higher playback counts can increase heat and hardware decoder load.',
                style: TextStyle(color: Color(0xFFE67E22), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayingVideoGrid extends StatelessWidget {
  const _PlayingVideoGrid({
    super.key,
    required this.assets,
    required this.columns,
    required this.active,
    required this.selectedIds,
    required this.onToggleSelection,
  });

  final List<AssetEntity> assets;
  final int columns;
  final bool active;
  final Set<String> selectedIds;
  final ValueChanged<AssetEntity> onToggleSelection;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final actualColumns = math.min(columns, math.max(1, assets.length));
        final rows = (assets.length / actualColumns).ceil();
        final tileWidth =
            (constraints.maxWidth - (actualColumns - 1) * 3) / actualColumns;
        final tileHeight =
            (constraints.maxHeight - (rows - 1) * 3) / math.max(1, rows);
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? const Color(0xFF3182F6) : Colors.transparent,
              width: 3,
            ),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: actualColumns,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: tileWidth / math.max(1, tileHeight),
            ),
            itemCount: assets.length,
            itemBuilder: (_, index) => _PlayingVideoTile(
              key: ValueKey('${assets[index].id}_$active'),
              asset: assets[index],
              active: active,
              selected: selectedIds.contains(assets[index].id),
              selectionNumber:
                  selectedIds.toList().indexOf(assets[index].id) + 1,
              onToggleSelection: () => onToggleSelection(assets[index]),
            ),
          ),
        );
      },
    );
  }
}

class _PlayingVideoTile extends StatefulWidget {
  const _PlayingVideoTile({
    super.key,
    required this.asset,
    required this.active,
    required this.selected,
    required this.selectionNumber,
    required this.onToggleSelection,
  });

  final AssetEntity asset;
  final bool active;
  final bool selected;
  final int selectionNumber;
  final VoidCallback onToggleSelection;

  @override
  State<_PlayingVideoTile> createState() => _PlayingVideoTileState();
}

class _PlayingVideoTileState extends State<_PlayingVideoTile> {
  VideoPlayerController? _controller;
  late final Future<Uint8List?> _thumbnail;

  @override
  void initState() {
    super.initState();
    _thumbnail = widget.asset.thumbnailDataWithSize(
      const ThumbnailSize.square(500),
      quality: 78,
    );
    if (widget.active) _startPlayback();
  }

  Future<void> _startPlayback() async {
    final file = await widget.asset.file;
    if (!mounted || !widget.active || file == null) return;
    final controller = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(true);
      await controller.play();
      if (!mounted || !widget.active) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (error, stackTrace) {
      debugPrint(
        'Gallery playback failed for ${widget.asset.id}: $error\n$stackTrace',
      );
      await controller.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant _PlayingVideoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _startPlayback();
    if (!widget.active && oldWidget.active) {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggleSelection,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<Uint8List?>(
            future: _thumbnail,
            builder: (_, snapshot) => snapshot.data == null
                ? const ColoredBox(color: Color(0xFF222222))
                : Image.memory(snapshot.data!, fit: BoxFit.cover),
          ),
          if (_controller?.value.isInitialized == true)
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          Positioned(
            left: 6,
            bottom: 6,
            child: _DurationBadge(seconds: widget.asset.duration),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: widget.selected
                    ? const Color(0xFF3182F6)
                    : Colors.black54,
                child: widget.selected
                    ? Text(
                        '${widget.selectionNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const Icon(
                        Icons.circle_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoNavigationThumbnail extends StatefulWidget {
  const _VideoNavigationThumbnail({
    required this.asset,
    required this.inPlayingGroup,
    required this.selected,
    required this.selectionNumber,
    required this.onNavigate,
    required this.onToggleSelection,
  });

  final AssetEntity asset;
  final bool inPlayingGroup;
  final bool selected;
  final int selectionNumber;
  final VoidCallback onNavigate;
  final VoidCallback onToggleSelection;

  @override
  State<_VideoNavigationThumbnail> createState() =>
      _VideoNavigationThumbnailState();
}

class _VideoNavigationThumbnailState extends State<_VideoNavigationThumbnail> {
  late final Future<Uint8List?> _thumbnail;

  @override
  void initState() {
    super.initState();
    _thumbnail = widget.asset.thumbnailDataWithSize(
      const ThumbnailSize.square(200),
      quality: 70,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onNavigate,
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: widget.inPlayingGroup
                ? const Color(0xFF3182F6)
                : Colors.transparent,
            width: 3,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List?>(
              future: _thumbnail,
              builder: (_, snapshot) => snapshot.data == null
                  ? const ColoredBox(color: Color(0xFF252525))
                  : Image.memory(snapshot.data!, fit: BoxFit.cover),
            ),
            Positioned(
              right: 3,
              top: 3,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onToggleSelection,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: widget.selected
                      ? const Color(0xFF3182F6)
                      : Colors.black54,
                  child: widget.selected
                      ? Text(
                          '${widget.selectionNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}
