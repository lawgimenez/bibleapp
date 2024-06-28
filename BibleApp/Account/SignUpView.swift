//
//  SignUpView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/16/24.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var authObservable: AuthObservable
    @State private var showPassword = false
    
    var body: some View {
        VStack {
            TextField("Email Address", text: $authObservable.email)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                #endif
                .padding(.bottom, 10)
            if showPassword {
                TextField("Password", text: $authObservable.password)
                    .autocorrectionDisabled(true)
                    .overlay(togglePasswordOverlay, alignment: .trailing)
            } else {
                SecureField("Password", text: $authObservable.password)
                    .autocorrectionDisabled(true)
                    .overlay(togglePasswordOverlay, alignment: .trailing)
            }
            Button {
                Task {
                    await signUp()
                }
            } label: {
                if authObservable.isSigningUp {
                    ProgressView()
                        .background(Color(.clear))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                } else {
                    Text("Sign Up")
                        .foregroundStyle(Color(.white))
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding([.top, .bottom], 5)
                        .dynamicTypeSize(.small)
                }
            }
            .frame(height: 40)
            .background(.buttonAccent)
            .contentShape(Rectangle())
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding([.bottom, .top], 10)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .textFieldStyle(CustomTextFieldStyle())
        .buttonStyle(.bordered)
        .contentShape(Rectangle())
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
    
    private func signUp() async {
        if !authObservable.email.isEmpty && !authObservable.password.isEmpty {
            authObservable.isSigningUp = true
            do {
                try await authObservable.signUp()
            } catch {
                print("Sign up error: \(error)")
                authObservable.isSigningUp = false
                authObservable.signUpStatus = .failed
            }
        }
    }
}

//#Preview {
//    SignUpView()
//}
