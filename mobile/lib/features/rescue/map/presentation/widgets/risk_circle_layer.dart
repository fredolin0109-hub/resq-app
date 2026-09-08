import 'package:flutter/material.dart';
import '../../domain/entities/city_risk_entity.dart';

/// Custom high-performance visual layer for rendering severity risk circles on the map.
class RiskCircleLayer extends StatelessWidget {
  final List<CityRiskEntity> cities;
  final CityRiskEntity? selectedCity;
  final ValueChanged<CityRiskEntity> onCityTapped;
  final bool showRiskCircles;

  const RiskCircleLayer({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onCityTapped,
    this.showRiskCircles = true,
  });

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
    return Stack(
      clipBehavior: Clip.none,
      children: cities.map((city) {
        final isSelected = selectedCity?.id == city.id;
        final riskColor = _getRiskColor(city.riskLevel);
        final baseSize = (city.severityRadiusKm * 2.2).clamp(36.0, 80.0);

        return Positioned(
          // Relative geographic placement projection for Tamil Nadu grid (Lat 8.0..13.5, Long 76.2..80.5)
          left: ((city.longitude - 76.2) / (80.5 - 76.2) * (MediaQuery.of(context).size.width - 60))
              .clamp(16.0, MediaQuery.of(context).size.width - 80.0),
          top: (((13.5 - city.latitude) / (13.5 - 8.0)) * (MediaQuery.of(context).size.height * 0.55))
              .clamp(30.0, (MediaQuery.of(context).size.height * 0.55)),
          child: GestureDetector(
            onTap: () => onCityTapped(city),
            child: Semantics(
              button: true,
              label: '${city.name}, ${city.district}: ${city.riskLevel.name} with ${city.riskPercentage}% risk.',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Risk Circle Pulse Target
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? baseSize * 1.2 : baseSize,
                    height: isSelected ? baseSize * 1.2 : baseSize,
                    decoration: BoxDecoration(
                      color: showRiskCircles
                          ? riskColor.withValues(alpha: isSelected ? 0.45 : 0.22)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : riskColor,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: riskColor.withValues(alpha: 0.6),
                                blurRadius: 16,
                                spreadRadius: 3,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: riskColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),

                  // 2. Clear City Label Badge (No overflow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? Colors.white : riskColor.withValues(alpha: 0.8),
                        width: isSelected ? 1.5 : 0.8,
                      ),
                    ),
                    child: Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
