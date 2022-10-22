//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-10.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
        .listRowBackground(selection.mainColor)
        .foregroundColor(selection.accentColor)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ThemePicker(selection: .constant(.seafoam))
    }
}
