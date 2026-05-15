import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/recommendation/data/models/place_model.dart';
import 'package:money_care/features/recommendation/presentation/services/place_checkin_service.dart';
import 'package:money_care/features/recommendation/presentation/utils/place_query_utils.dart';

class PlaceCheckinSheet extends StatefulWidget {
  final int transactionId;
  final String initialQuery;

  const PlaceCheckinSheet({
    super.key,
    required this.transactionId,
    required this.initialQuery,
  });

  static Future<void> show({
    required int transactionId,
    String? initialQuery,
  }) async {
    await Get.bottomSheet<void>(
      PlaceCheckinSheet(
        transactionId: transactionId,
        initialQuery: initialQuery?.trim().isNotEmpty == true
            ? initialQuery!.trim()
            : 'quán ăn',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  State<PlaceCheckinSheet> createState() => _PlaceCheckinSheetState();
}

class _PlaceCheckinSheetState extends State<PlaceCheckinSheet> {
  final PlaceCheckinService service = Get.find<PlaceCheckinService>();
  final MapController mapController = MapController();
  late final TextEditingController searchController;
  late final TextEditingController locationController;
  late final TextEditingController manualNameController;

  static const LatLng _hanoiCenter = LatLng(21.0285, 105.8542);
  static const String _currentLocationLabel = 'Vị trí hiện tại';
  static const String _defaultRasterTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const List<String> _quickQueries = [
    'Quán ăn',
    'Cafe',
    'Cơm',
    'Phở',
    'Trà sữa',
  ];

  bool isLoadingLocation = true;
  bool isResolvingLocation = false;
  bool isLoadingPlaces = false;
  bool isSaving = false;
  bool locationUnavailable = false;
  bool wantToReturn = true;
  bool showManualInput = false;
  int rating = 5;
  double zoom = 16;
  LatLng? currentPosition;
  LatLng searchCenter = _hanoiCenter;
  LatLng pin = _hanoiCenter;
  PlaceModel? selectedPlace;
  List<PlaceModel> places = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(
      text: normalizePlaceQuery(widget.initialQuery),
    );
    locationController = TextEditingController(text: _currentLocationLabel);
    manualNameController = TextEditingController(text: 'Địa điểm đã chọn');
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      isLoadingLocation = true;
      locationUnavailable = false;
    });

    try {
      final position = await service.currentPosition();
      if (position != null) {
        currentPosition = LatLng(position.latitude, position.longitude);
        searchCenter = currentPosition!;
        pin = searchCenter;
        locationController.text = _currentLocationLabel;
      } else {
        locationUnavailable = true;
        locationController.text = 'Hà Nội';
      }
    } catch (_) {
      locationUnavailable = true;
      locationController.text = 'Hà Nội';
    }

    if (!mounted) return;
    setState(() => isLoadingLocation = false);
    _movePreviewMap(pin);
    await _search();
  }

  Future<void> _resolveLocationAndSearch() async {
    final locationText = locationController.text.trim();
    if (locationText.isEmpty || locationText == _currentLocationLabel) {
      if (currentPosition != null) {
        setState(() {
          searchCenter = currentPosition!;
          pin = searchCenter;
          locationController.text = _currentLocationLabel;
        });
        _movePreviewMap(pin);
        await _search();
        return;
      }
      await _loadLocation();
      return;
    }

    setState(() => isResolvingLocation = true);
    try {
      final resolved = await service.resolveLocation(locationText);
      if (!mounted) return;
      if (resolved == null) {
        AppHelperFunction.showErrorSnackBar('Không tìm thấy khu vực này');
        return;
      }
      setState(() {
        searchCenter = LatLng(resolved.latitude, resolved.longitude);
        pin = searchCenter;
        locationController.text = resolved.label.isNotEmpty
            ? resolved.label
            : locationText;
      });
      _movePreviewMap(pin);
      await _search();
    } finally {
      if (mounted) setState(() => isResolvingLocation = false);
    }
  }

  Future<void> _search() async {
    final query = normalizePlaceQuery(searchController.text);
    if (query.isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoadingPlaces = true);
    try {
      debugPrint(
        '[PlaceCheckin] search query="$query" lat=${searchCenter.latitude} lng=${searchCenter.longitude}',
      );
      final result = await service.searchPlaces(
        query: query,
        latitude: searchCenter.latitude,
        longitude: searchCenter.longitude,
      );
      debugPrint('[PlaceCheckin] search result count=${result.length}');
      if (!mounted) return;
      setState(() {
        places = result.take(10).toList();
        selectedPlace = null;
        pin = searchCenter;
        showManualInput = places.isEmpty;
      });
      _movePreviewMap(pin);
    } catch (error) {
      AppHelperFunction.showErrorSnackBar(error.toString());
      if (!mounted) return;
      setState(() {
        places = [];
        selectedPlace = null;
        showManualInput = true;
      });
    } finally {
      if (mounted) setState(() => isLoadingPlaces = false);
    }
  }

  void _selectQuickQuery(String query) {
    searchController.text = query;
    _search();
  }

  void _selectPlace(PlaceModel place) {
    final nextPin = LatLng(place.latitude, place.longitude);
    setState(() {
      selectedPlace = place;
      pin = nextPin;
      manualNameController.text = place.name;
      showManualInput = false;
    });
    _movePreviewMap(nextPin);
  }

  void _movePreviewMap(LatLng center) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        mapController.move(center, zoom);
      } catch (_) {
        // FlutterMap may not be mounted yet when search completes quickly.
      }
    });
  }

  Future<void> _save() async {
    if (isSaving) return;
    if (selectedPlace == null && !showManualInput) {
      setState(() => showManualInput = true);
      return;
    }

    final place =
        selectedPlace ??
        PlaceModel.manual(
          name: manualNameController.text.trim().isNotEmpty
              ? manualNameController.text.trim()
              : 'Địa điểm đã chọn',
          address: locationController.text.trim(),
          latitude: pin.latitude,
          longitude: pin.longitude,
        );

    setState(() => isSaving = true);
    try {
      final success = await service.createCheckin(
        transactionId: widget.transactionId,
        place: place,
        rating: rating,
        wantToReturn: wantToReturn,
        note: selectedPlace?.name ?? manualNameController.text.trim(),
      );
      if (success) {
        AppHelperFunction.showSuccessSnackBar('Đã check-in địa điểm');
        Get.back();
      } else {
        AppHelperFunction.showErrorSnackBar('Không thể check-in địa điểm');
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height * 0.9;
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Check-in địa điểm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationField(),
                      const SizedBox(height: 10),
                      _buildSearchField(),
                      const SizedBox(height: 10),
                      _buildQuickQueryChips(),
                      if (locationUnavailable) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Chưa lấy được vị trí hiện tại. Bạn có thể nhập khu vực để tìm địa điểm.',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _buildPlaceList(),
                      const SizedBox(height: 10),
                      _buildManualSection(),
                      if (selectedPlace != null || showManualInput) ...[
                        const SizedBox(height: 10),
                        SizedBox(height: 160, child: _buildMapPreview()),
                      ],
                      const SizedBox(height: 8),
                      _buildRatingRow(),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: wantToReturn,
                        onChanged: (value) =>
                            setState(() => wantToReturn = value),
                        title: const Text('Muốn quay lại lần sau'),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          icon: isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_rounded),
                          label: Text(
                            selectedPlace == null && !showManualInput
                                ? 'Chọn địa điểm hoặc tự nhập'
                                : 'Lưu check-in',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: locationController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _resolveLocationAndSearch(),
      decoration: InputDecoration(
        labelText: 'Khu vực tìm kiếm',
        prefixIcon: const Icon(Icons.my_location_outlined),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isResolvingLocation || isLoadingLocation)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            IconButton(
              tooltip: 'Dùng vị trí hiện tại',
              onPressed: isLoadingLocation ? null : _loadLocation,
              icon: const Icon(Icons.near_me_rounded),
            ),
            IconButton(
              tooltip: 'Tìm khu vực',
              onPressed: isResolvingLocation ? null : _resolveLocationAndSearch,
              icon: const Icon(Icons.search_rounded),
            ),
          ],
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _search(),
      decoration: InputDecoration(
        labelText: 'Tìm địa điểm',
        hintText: 'Nhập cơm, cafe, phở hoặc tên quán...',
        prefixIcon: const Icon(Icons.storefront_outlined),
        suffixIcon: IconButton(
          onPressed: isLoadingPlaces ? null : _search,
          icon: const Icon(Icons.refresh_rounded),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildQuickQueryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _quickQueries.map((query) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(query),
              onPressed: () => _selectQuickQuery(query),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlaceList() {
    if (isLoadingPlaces) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (places.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Không tìm thấy địa điểm gần khu vực này.',
            style: TextStyle(color: AppColors.text4),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final place = places[index];
        final selected = selectedPlace?.id == place.id;
        return ListTile(
          dense: true,
          selected: selected,
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            selected ? Icons.check_circle_rounded : Icons.place_outlined,
            color: selected ? AppColors.primary : AppColors.secondaryNavyBlue,
          ),
          title: Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.address.isNotEmpty)
                Text(
                  place.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                [
                  place.provider,
                  if (place.distance != null) '${place.distance!.round()} m',
                ].join(' • '),
                style: TextStyle(color: AppColors.text4, fontSize: 12),
              ),
            ],
          ),
          onTap: () => _selectPlace(place),
        );
      },
    );
  }

  Widget _buildManualSection() {
    if (!showManualInput) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() {
            showManualInput = true;
            selectedPlace = null;
            pin = searchCenter;
          }),
          icon: const Icon(Icons.edit_location_alt_outlined),
          label: const Text('Không thấy địa điểm? Tự nhập'),
        ),
      );
    }

    return TextField(
      controller: manualNameController,
      decoration: InputDecoration(
        labelText: 'Tên địa điểm tự nhập',
        prefixIcon: const Icon(Icons.edit_location_alt_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildMapPreview() {
    if (isLoadingLocation) {
      return const _MapMessage(
        icon: Icons.my_location_rounded,
        text: 'Đang lấy vị trí hiện tại...',
      );
    }

    final mapTilesKey = dotenv.env['GOONG_MAPTILES_KEY']?.trim() ?? '';
    final configuredTemplate = dotenv.env['GOONG_MAPTILES_URL']?.trim();
    final template = configuredTemplate != null && configuredTemplate.isNotEmpty
        ? configuredTemplate
        : _defaultRasterTileUrl;
    if (template.contains('{apiKey}') && mapTilesKey.isEmpty) {
      return _MapMessage(
        icon: Icons.map_outlined,
        text: 'Thiếu GOONG_MAPTILES_KEY trong file .env',
      );
    }
    final urlTemplate = template.replaceAll('{apiKey}', mapTilesKey);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: pin,
          initialZoom: zoom,
          onPositionChanged: (camera, _) => zoom = camera.zoom,
        ),
        children: [
          TileLayer(
            urlTemplate: urlTemplate,
            userAgentPackageName: 'com.example.doan_cn',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: pin,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.place_rounded,
                  color: AppColors.expense,
                  size: 38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Text('Đánh giá'),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          final value = index + 1;
          return IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => rating = value),
            icon: Icon(
              value <= rating ? Icons.star : Icons.star_border,
              color: Colors.amber.shade700,
            ),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    manualNameController.dispose();
    super.dispose();
  }
}

class _MapMessage extends StatelessWidget {
  const _MapMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.text4),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
