//
//  SignInView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import SwiftUI
import OSLog

private let logger = Logger(subsystem: "com.infinalab", category: "Sign In")

struct SignInView: View {
    
    @EnvironmentObject private var authObservable: AuthObservable
    @FocusState private var isFocusedEmail: Bool
    @FocusState private var isFocusedPassword: Bool
    @State private var showPassword = false
    
    var body: some View {
        VStack {
            Image("")
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 30)
                .padding(.bottom, 50)
            TextField("Email Address", text: $authObservable.email)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                #endif
                .padding(.bottom, 10)
                .autocorrectionDisabled(true)
                .focused($isFocusedEmail)
                .submitLabel(.next)
                .onSubmit {
                    logger.debug("Email return key")
                    isFocusedEmail = false
                    isFocusedPassword = true
                }
            if showPassword {
                TextField("Password", text: $authObservable.password)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .submitLabel(.done)
                    .focused($isFocusedPassword)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        Task {
                            await signIn()
                        }
                    }
                    .overlay(togglePasswordOverlay, alignment: .trailing)
            } else {
                SecureField("Password", text: $authObservable.password)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .submitLabel(.done)
                    .focused($isFocusedPassword)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        Task {
                            await signIn()
                        }
                    }
                    .overlay(togglePasswordOverlay, alignment: .trailing)
            }
            Button {
                Task {
                    await signIn()
                }
            } label: {
                if authObservable.isSigningIn {
                    ProgressView()
                        .background(Color(.clear))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .tint(Color(.white))
                } else {
                    Text("Sign In")
                        .foregroundStyle(Color(.white))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .padding([.top, .bottom], 5)
                        .dynamicTypeSize(.small)
                }
            }
            .frame(height: 45)
            .contentShape(Rectangle())
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding([.bottom, .top], 10)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var togglePasswordOverlay: some View {
        Image(systemName: showPassword ? "eye" : "eye.slash")
            .frame(width: 40, height: 40)
            .contentShape(Rectangle())
            .padding(.trailing, 10)
            .onTapGesture {
                showPassword.toggle()
            }
    }
    
    private func signIn() async {
        if !authObservable.email.isEmpty && !authObservable.password.isEmpty {
//            authObservable.isSigningIn = true
//            do {
//                try await authObservable.signIn()
//            } catch {
//                logger.debug("Sign in error = \(error)")
//                authObservable.isSigningIn = false
//                authObservable.status =  .loggedOut
//            }
            authObservable.email = ""
            authObservable.password = ""
        }
    }
}

#Preview {
    SignInView()
}
