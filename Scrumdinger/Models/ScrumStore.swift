//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Mitul Vaghamshi on 2022-10-14.
//

import Foundation

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: false)
            .appendingPathComponent("scrums.data")
    }
    
    static func load() async throws -> [DailyScrum] {
        try await withUnsafeThrowingContinuation { continueation in
            load { result in
                switch result {
                case .success(let scrums):
                    continueation.resume(returning: scrums)
                case .failure(let error):
                    continueation.resume(throwing: error)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async { completion(.success([])) }
                    return
                }
                let dailyScrums = try JSONDecoder()
                    .decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async { completion(.success(dailyScrums)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withUnsafeThrowingContinuation { continueation in
            save(scrums: scrums) { result in
                switch result {
                case .success(let count):
                    continueation.resume(returning: count)
                case .failure(let error):
                    continueation.resume(throwing: error)
                }
            }
        }
    }
    
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outFile = try fileURL()
                try data.write(to: outFile)
                DispatchQueue.main.async { completion(.success(data.count)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
