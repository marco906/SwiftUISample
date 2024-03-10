//
//  WelcomeView.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 09/03/2024.
//

import SwiftUI
import Lottie

struct WelcomeViewArguments: Hashable {
    var user: User? = nil
}

struct WelcomeView: View {
    @StateObject var model = WelcomeViewModel()
    let user: User?
    
    init(_ args: WelcomeViewArguments) {
        self.user = args.user
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden()
            .task {
                start()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch model.state {
        case .loading:
            ProgressView(Strings.loadingDescription)
        case let .normal(user):
            welcome(user: user)
        case let .error(msg):
            error(msg)
        }
    }
    
    func welcome(user: User) -> some View {
        List {
            Section(Strings.welcomeHeaderSectionTitle) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(Strings.welcomeHeaderTitle(arg1: user.name))
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(Strings.welcomeHeaderMsg)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
            }
            
            Section(Strings.welcomeProfileSectionTitle) {
                LabeledContent(Strings.registerFieldNameTitle, value: user.name)
                LabeledContent(Strings.registerFieldEmailTitle, value: user.email)
                LabeledContent(Strings.registerFieldBirthdayTitle, value: user.birthdayDisplay)
            }
            
            animation
        }
        .navigationTitle(Strings.welcomeNavigationTitle)
    }
    
    var animation: some View {
        LottieView(animation: .named("astronaut"))
            .animationSpeed(1.5)
            .looping()
            .frame(height: 250)
            .listRowBackground(Color.clear)
            .accessibilityLabel(Strings.welcomeAnimationDescription)
    }
    
    func error(_ msg: LocalizedStringKey) -> some View {
        List {
            Section(Strings.welcomeErrorSectionTitle) {
                VStack(alignment: .leading) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(Color.red)
                        .font(.system(size: 32))
                        .fontWeight(.semibold)
                        .padding(.bottom, 2)
                    Text(Strings.errorGeneralTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(msg)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Button(Strings.buttonRetry) {
                    model.reload()
                }
            }
        }
    }
    
    func start() {
        model.setup(user: user)
        model.start()
    }
}

#Preview {
    NavigationStack {
        WelcomeView(
            WelcomeViewArguments(user: User(name: "Max Muster", email: "max.mustermann@example.com", birthday: Date.now))
        )
    }
}
