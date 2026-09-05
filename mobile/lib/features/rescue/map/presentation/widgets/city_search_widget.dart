import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';

/// Autocomplete Search Widget for searching Tamil Nadu by City, District, or Area.
class CitySearchWidget extends StatefulWidget {
  final List<CityRiskEntity> cities;
  final ValueChanged<CityRiskEntity> onCitySelected;
  final VoidCallback? onClear;

  const CitySearchWidget({
    super.key,
    required this.cities,
    required this.onCitySelected,
    this.onClear,
  });

  @override
  State<CitySearchWidget> createState() => _CitySearchWidgetState();
}

class _CitySearchWidgetState extends State<CitySearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.highRisk:
        return Colors.red.shade700;
      case RiskLevel.moderate:
        return Colors.amber.shade800;
      case RiskLevel.safe:
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Search city, district, or area in Tamil Nadu',
      textField: true,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Autocomplete<CityRiskEntity>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.toLowerCase().trim();
            if (query.isEmpty) {
              return const Iterable<CityRiskEntity>.empty();
            }
            return widget.cities.where((city) {
              return city.name.toLowerCase().contains(query) ||
                  city.district.toLowerCase().contains(query) ||
                  city.area.toLowerCase().contains(query);
            });
          },
          displayStringForOption: (CityRiskEntity city) => '${city.name}, ${city.district}',
          onSelected: (CityRiskEntity selection) {
            _controller.text = selection.name;
            _focusNode.unfocus();
            widget.onCitySelected(selection);
          },
          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Search City, District, Area (e.g. Palani, Madurai)',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                ),
                suffixIcon: textController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        tooltip: 'Clear search',
                        onPressed: () {
                          textController.clear();
                          widget.onClear?.call();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: InputBorder.none,
                filled: false,
              ),
              textInputAction: TextInputAction.search,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.surface,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280, maxWidth: 360),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final city = options.elementAt(index);
                      final riskColor = _getRiskColor(city.riskLevel);

                      return ListTile(
                        dense: true,
                        leading: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: riskColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          city.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${city.district} District • ${city.area}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            city.riskLevel.name.toUpperCase(),
                            style: TextStyle(
                              color: riskColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => onSelected(city),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
