//
//  RectangleView.swift
//  Moonshot
//
//  Created by Malak Yehia on 08/02/2025.
//

import SwiftUI

struct RectangleView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    RectangleView()
}
