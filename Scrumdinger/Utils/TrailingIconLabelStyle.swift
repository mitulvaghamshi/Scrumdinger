//
//  TrailingIconLabelStyle.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-08.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
