//
//  Publisher+Async.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//
import Combine

extension Publisher {

    /// Awaits the first value emitted by a publisher.
    /// Useful for bridging Combine to async/await.
    func asyncValue() async throws -> Output {

        var cancellable: AnyCancellable?

        return try await withTaskCancellationHandler {

            try await withCheckedThrowingContinuation { continuation in

                cancellable = self
                    .first()
                    .sink(
                        receiveCompletion: { completion in

                            switch completion {

                            case .finished:
                                break

                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }

                            cancellable?.cancel()
                            cancellable = nil
                        },

                        receiveValue: { value in
                            continuation.resume(returning: value)
                        }
                    )
            }

        } onCancel: {
            cancellable?.cancel()
            cancellable = nil
        }
    }
}

extension Publisher where Failure == Never {

    func asyncValue() async -> Output {

        var cancellable: AnyCancellable?

        return await withTaskCancellationHandler {

            await withCheckedContinuation { continuation in

                cancellable = self
                    .first()
                    .sink { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                        cancellable = nil
                    }
            }

        } onCancel: {
            cancellable?.cancel()
            cancellable = nil
        }
    }
}
