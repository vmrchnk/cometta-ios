import SwiftUI

extension OnboardingView {
    struct FourthPage: View {
        @Environment(\.theme) var theme
        @Binding var currentPage: Int
        @Bindable var viewModel: OnboardingViewModel
        @State private var searchText = ""
        @State private var searchResults: [Location] = []
        @State private var selectedLocation: Location?
        @State private var isSearching = false
        @State private var searchTask: Task<Void, Never>?
        @FocusState private var isTextFieldFocused: Bool

        private let locationService = LocationSearchService()

        var body: some View {
            VStack(spacing: 24) {
                // Title
                Text("Place of birth?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .padding(.top, 20)

                // Description
                Text("Your birth location helps create a more accurate astrological chart")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Search field
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        // Search icon
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(theme.colors.primary)
                            .font(.system(size: 18, weight: .medium))

                        // Text field
                        TextField("Enter city name", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(theme.colors.onBackground)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                            .focused($isTextFieldFocused)
                            .onChange(of: searchText) { _, newValue in
                                handleSearchTextChange(newValue)
                            }

                        // Clear button
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                searchResults = []
                                selectedLocation = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(theme.colors.onSurface.opacity(0.5))
                                    .font(.system(size: 18))
                            }
                        }

                        // Loading indicator
                        if isSearching {
                            ProgressView()
                                .tint(theme.colors.primary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(theme.colors.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                searchText.isEmpty ?
                                theme.colors.onSurface.opacity(0.2) :
                                theme.colors.primary.opacity(0.5),
                                lineWidth: 2
                            )
                    )
                }
                .padding(.horizontal, 24)

                // Selected location display
                if let location = selectedLocation {
                    SelectedLocationView(location: location, theme: theme)
                        .transition(.scale.combined(with: .opacity))
                }

                // Search results list
                if !searchResults.isEmpty && selectedLocation == nil {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(searchResults) { location in
                                LocationResultRow(location: location, theme: theme)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedLocation = location
                                            viewModel.selectedLocation = location
                                            searchText = location.name
                                            searchResults = []
                                            isTextFieldFocused = false
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .frame(maxHeight: 300)
                    .transition(.move(edge: .top).combined(with: .opacity))
                } else if searchText.count >= 2 && searchResults.isEmpty && !isSearching && selectedLocation == nil {
                    // No results found
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash")
                            .font(.system(size: 40))
                            .foregroundStyle(theme.colors.onSurface.opacity(0.3))

                        Text("No locations found")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(theme.colors.onSurface.opacity(0.5))
                    }
                    .padding(.top, 40)
                    .transition(.opacity)
                }

                Spacer()
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: searchResults.isEmpty)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedLocation)
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused = false
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTextFieldFocused = true
                }
            }
            .onDisappear {
                isTextFieldFocused = false
            }
            .onChange(of: currentPage) { _, newPage in
                if newPage != 3 {
                    isTextFieldFocused = false
                }
            }
        }

        private func handleSearchTextChange(_ newValue: String) {
            // Cancel previous search
            searchTask?.cancel()

            // Clear results if search is empty
            guard newValue.count >= 2 else {
                searchResults = []
                selectedLocation = nil
                return
            }

            // Debounce: wait 500ms before searching
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000)

                guard !Task.isCancelled else { return }

                await performSearch(query: newValue)
            }
        }

        private func performSearch(query: String) async {
            isSearching = true

            do {
                let results = try await locationService.searchLocations(query: query)

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    searchResults = results
                    isSearching = false
                }
            } catch {
                await MainActor.run {
                    searchResults = []
                    isSearching = false
                }
            }
        }
    }
}

// MARK: - Selected Location View
struct SelectedLocationView: View {
    let location: Location
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 16) {
            // Location icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.colors.primary.opacity(0.2),
                                theme.colors.primaryVariant.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.colors.primary)
            }

            // Location details
            VStack(spacing: 8) {
                Text(location.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(theme.colors.onBackground)
                    .multilineTextAlignment(.center)

                Text(location.displayName)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.colors.primary.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Location Result Row
struct LocationResultRow: View {
    let location: Location
    let theme: AppTheme

    var body: some View {
        HStack(spacing: 12) {
            // Location icon
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(theme.colors.primary)

            // Location text
            VStack(alignment: .leading, spacing: 4) {
                Text(location.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(theme.colors.onBackground)

                Text(location.displayName)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(theme.colors.onSurface.opacity(0.6))
                    .lineLimit(1)
            }

            Spacer()

            // Type badge
            Text(location.type.capitalized)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(theme.colors.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(theme.colors.primary.opacity(0.1))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.colors.onSurface.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Previews
#Preview("Light") {
    OnboardingView.FourthPage(currentPage: .constant(3), viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    OnboardingView.FourthPage(currentPage: .constant(3), viewModel: OnboardingViewModel())
        .theme(.default)
        .preferredColorScheme(.dark)
}
