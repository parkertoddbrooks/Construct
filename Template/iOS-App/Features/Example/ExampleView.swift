//
//  ExampleView.swift
//  Construct Template
//
//  Created by Construct
//

import SwiftUI

struct ExampleView: View {
    @StateObject private var viewModel: ExampleViewModel
    @State private var isShowingDetail = false  // UI state only
    
    private let tokens: ExampleTokens
    
    init(tokens: ExampleTokens = .default) {
        self.tokens = tokens
        self._viewModel = StateObject(wrappedValue: ExampleViewModel())
    }
    
    var body: some View {
        ZStack {
            // Multi-layer background (prevents flashes)
            backgroundLayer
            
            VStack(spacing: tokens.spacing) {
                headerSection
                contentSection
                actionSection
            }
            .padding(tokens.padding)
        }
        .task {
            await viewModel.loadData()
        }
        .alert("Error", isPresented: $isShowingDetail) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onReceive(viewModel.$hasError) { hasError in
            isShowingDetail = hasError
        }
    }
    
    // MARK: - View Components
    
    private var backgroundLayer: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all, edges: .all)
            Color.background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: tokens.headerSpacing) {
            Text("Welcome to Construct")
                .font(.largeTitle)
                .accessibilityAddTraits(.isHeader)
            
            Text("This is an example feature")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: tokens.contentSpacing) {
            if viewModel.isLoading {
                ProgressView()
                    .accessibilityLabel("Loading data")
            } else {
                ForEach(viewModel.items) { item in
                    ItemRow(item: item, tokens: tokens)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var actionSection: some View {
        HStack(spacing: tokens.buttonSpacing) {
            Button("Refresh") {
                Task {
                    await viewModel.refresh()
                }
            }
            .buttonStyle(PrimaryButtonStyle(tokens: tokens))
            .disabled(viewModel.isLoading)
            
            Button("Clear") {
                viewModel.clear()
            }
            .buttonStyle(SecondaryButtonStyle(tokens: tokens))
            .disabled(viewModel.items.isEmpty)
        }
    }
}

// MARK: - Subviews

private struct ItemRow: View {
    let item: ExampleItem
    let tokens: ExampleTokens
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .foregroundColor(.accentColor)
                .accessibilityLabel("\(item.title) icon")
            
            VStack(alignment: .leading, spacing: tokens.itemSpacing) {
                Text(item.title)
                    .font(.headline)
                
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(item.value)
                .font(.body)
                .foregroundColor(.accentColor)
        }
        .padding(tokens.itemPadding)
        .background(Color.secondaryBackground)
        .cornerRadius(tokens.cornerRadius)
    }
}

// MARK: - Button Styles

private struct PrimaryButtonStyle: ButtonStyle {
    let tokens: ExampleTokens
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, tokens.buttonPaddingH)
            .padding(.vertical, tokens.buttonPaddingV)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(tokens.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

private struct SecondaryButtonStyle: ButtonStyle {
    let tokens: ExampleTokens
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, tokens.buttonPaddingH)
            .padding(.vertical, tokens.buttonPaddingV)
            .background(Color.secondaryBackground)
            .foregroundColor(.accentColor)
            .cornerRadius(tokens.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    ExampleView()
}

#Preview("Dark Mode") {
    ExampleView()
        .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    ExampleView()
        .environment(\.dynamicTypeSize, .xxxLarge)
}