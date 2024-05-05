class SettingsState {
  final bool darkMode;
  final int allItemsFilter;
  final int defaultCategory;

  SettingsState({
    this.darkMode = false,
    this.allItemsFilter = 15,
    this.defaultCategory = 3,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? animationsOn,
    int? allItemsFilter,
    int? defaultCategory,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      allItemsFilter: allItemsFilter ?? this.allItemsFilter,
      defaultCategory: defaultCategory ?? this.defaultCategory,
    );
  }
}
