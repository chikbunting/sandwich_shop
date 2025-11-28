enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  /// Optional enum-backed type. When loading dynamically from JSON the
  /// type may be null if it doesn't map to one of the enum values.
  final SandwichType? type;

  /// A stable id for this sandwich (comes from JSON or derived from the
  /// enum name). Use this when matching assets or persisted data.
  final String id;

  /// Display name (may be provided by JSON). If null we fall back to the
  /// enum-derived name when available.
  final String? displayName;

  final String? description;
  final bool available;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
    String? id,
    this.displayName,
    this.description,
    this.available = true,
  }) : id = id ?? (type?.name ?? '');

  /// Create a Sandwich instance from JSON data. Expects a map with keys
  /// like `id`, `name`, `description`, and `available`.
  factory Sandwich.fromJson(Map<String, dynamic> json, {bool isFootlong = true, BreadType breadType = BreadType.white}) {
    final String rawId = json['id'] as String? ?? '';
    // Try to map the JSON id (e.g. "veggie_delight") to the SandwichType
    // enum by converting underscore_case to camelCase which matches the
    // enum names we used earlier.
    String camel = rawId.split('_').mapIndexed((i, part) {
      if (i == 0) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join();

    SandwichType? mappedType;
    for (final t in SandwichType.values) {
      if (t.name == camel) {
        mappedType = t;
        break;
      }
    }

    return Sandwich(
      type: mappedType,
      isFootlong: isFootlong,
      breadType: breadType,
      id: rawId,
      displayName: json['name'] as String?,
      description: json['description'] as String?,
      available: json['available'] as bool? ?? true,
    );
  }

  String get name {
    if (displayName != null && displayName!.isNotEmpty) return displayName!;
    final t = type;
    if (t == null) return id;
    switch (t) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    final base = id.isNotEmpty ? id : (type?.name ?? 'unknown');
    final sizeString = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${base}_$sizeString.png';
  }
}

// Small helper: mapIndexed for lists (kept local to avoid new dependencies)
extension _MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    int i = 0;
    for (final e in this) {
      yield f(i++, e);
    }
  }
}
