//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-08.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $store.scrums) {
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again leter.")
                            //fatalError("Error saving scrums, \(error.localizedDescription)")
                        }
                    }
                    //ScrumStore.save(scrums: store.scrums) { result in
                    //    if case .failure(let error) = result {
                    //        fatalError(error.localizedDescription)
                    //    }
                    //}
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                store.scrums = DailyScrum.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            //.onAppear {
            //    ScrumStore.load { result in
            //        switch result {
            //        case .success(let scrums):
            //            store.scrums = scrums
            //        case .failure(let error):
            //            fatalError(error.localizedDescription)
            //        }
            //    }
            //}
            .task {
                do {
                    let scrums = try await ScrumStore.load()
                    store.scrums = scrums
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Try again leter.")
                    //fatalError("Error loading scrums, \(error.localizedDescription)")
                }
            }
        }
    }
}

// xcrun simctl get_app_container booted me.mitul.Scrumdinger data
// /Users/mitulvaghamshi/Library/Developer/CoreSimulator/Devices/3237766D-5D6F-471D-9149-7FA9A079C5BD/data/Containers/Data/Application/7336C686-D3B2-48D4-B615-B77660EC840E/Documents/scrums.data
