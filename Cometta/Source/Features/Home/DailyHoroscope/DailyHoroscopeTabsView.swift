import SwiftUI

struct DailyHoroscopeTabsView: View {
    @Bindable var viewModel: DailyHoroscopeViewModel
    let theme: AppTheme

    var body: some View {
        ScrollViewReader { tabsProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DailyHoroscopeViewModel.LifeArea.allCases, id: \.self) { area in
                        TabButton(
                            title: area.rawValue,
                            isSelected: viewModel.selectedTab == area,
                            theme: theme
                        ) {
                            viewModel.isTabTap = true
                            withAnimation {
                                viewModel.selectedTab = area
                            }
                        }
                        .id(area)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 12)
            .background(theme.colors.background)
            .onChange(of: viewModel.selectedTab) { _, newTab in
                withAnimation {
                    tabsProxy.scrollTo(newTab, anchor: .center)
                }
            }
            .sensoryFeedback(.increase, trigger: viewModel.selectedTab)
        }
    }
}
