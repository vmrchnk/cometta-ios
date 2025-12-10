//
//  SettingsView.swift
//  Cometta
//
//  Created by Vadym on 12.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.theme) var theme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    Button(role: .destructive) {
                        dismiss()
                        // Small delay to allow sheet dismissal transition to start before root switch
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            NotificationCenter.default.post(name: .logout, object: nil)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .font(.system(size: 16, weight: .medium))
                    }
                    .listRowBackground(theme.colors.surface)
                    .listRowSeparatorTint(theme.colors.onSurface.opacity(0.1))
                    .foregroundStyle(Color.red) // Explicitly red for destructive action
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("Version \(version)")
                    .font(.caption)
                    .foregroundStyle(theme.colors.onSurface.opacity(0.4))
                    .padding(.bottom, 20)
            }
        }
        .background(theme.colors.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .theme(.default)
    }
}
