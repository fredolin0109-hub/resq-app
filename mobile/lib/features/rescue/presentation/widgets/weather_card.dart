import 'package:flutter/material.dart';
import '../../domain/entities/rescue_dashboard_data.dart';

/// Tactical meteorological forecasting widget.
class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      label: 'Weather info: Temperature ${weather.temperature}, ${weather.condition}, Rain ${weather.rainProbability}, Wind ${weather.wind}, Visibility ${weather.visibility}.',
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thunderstorm_rounded,
                      color: Colors.blueAccent.shade700,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tactical Weather',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  weather.temperature,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              weather.condition,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherMetric(
                  context,
                  icon: Icons.water_drop_rounded,
                  label: 'Rain',
                  value: weather.rainProbability,
                  iconColor: Colors.blue.shade600,
                ),
                _buildDivider(colorScheme),
                _buildWeatherMetric(
                  context,
                  icon: Icons.air_rounded,
                  label: 'Wind',
                  value: weather.wind,
                  iconColor: Colors.teal.shade600,
                ),
                _buildDivider(colorScheme),
                _buildWeatherMetric(
                  context,
                  icon: Icons.visibility_rounded,
                  label: 'Visibility',
                  value: weather.visibility,
                  iconColor: Colors.deepPurple.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 32,
      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }

  Widget _buildWeatherMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
