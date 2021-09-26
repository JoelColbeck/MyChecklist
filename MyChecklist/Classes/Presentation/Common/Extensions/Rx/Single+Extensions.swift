//
//  Single+Extensions.swift
//  mercury-ios
//
//  Created by Данил Коротаев on 05.07.2021.
//  Copyright © 2021 Trinity Monsters. All rights reserved.
//

import RxSwift

extension Single where Element == Void {
    static func never() -> Single<Void> {
        Single<Void>.create { _ -> Disposable in
            return Disposables.create()
        }
    }
    
    static func create() -> Single<Void> {
        Single<Void>.create { single -> Disposable in
            single(.success(()))
            return Disposables.create()
        }
    }
    
    static func create(for viewModel: InteractiveClosableViewModel) -> Single<Void> {
        Single<Void>.create { single -> Disposable in
            return viewModel.closed.bind {
                single(.success(()))
            }
        }
    }
    
    static func create(
        for viewModel: InteractiveClosableViewModel,
        with subject: PublishSubject<Void>) -> Single<Void> {
        return .create { single -> Disposable in
            return Disposables.create(viewModel.closed.bind {
                single(.success(()))
            }, subject.bind {
                single(.success(()))
                subject.onCompleted()
            })
        }
    }
    
    static func create<Result>(
        for viewModel: InteractiveClosableViewModel,
        with subject: PublishSubject<Result>,
        defaultResult: Result) -> Single<Result> {
        create(for: viewModel, with: subject, resultFactory: { defaultResult })
    }
    
    static func create<Result>(
        for viewModel: InteractiveClosableViewModel,
        with subject: PublishSubject<Result>,
        resultFactory: @escaping () -> Result
    ) -> Single<Result> {
        return .create { single -> Disposable in
            return Disposables.create(viewModel.closed.bind {
                single(.success(resultFactory()))
            }, subject.bind { result in
                single(.success(result))
            })
        }
    }
}


extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    func subscribe(_ onNext: @escaping (Element) -> Void) -> Disposable {
        self.subscribe(onSuccess: onNext)
    }
}
