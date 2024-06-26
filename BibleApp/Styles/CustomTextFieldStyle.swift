//
//  CustomTextFieldStyle.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/26/24.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding([.top, .bottom], 13)
            .padding([.leading, .trailing], 19)
            .frame(height: 55)
            .background(Color(.textFieldAccent))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tint(Color(.cursor))
    }
}
