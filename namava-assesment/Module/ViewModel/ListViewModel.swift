//
//  ListViewModel.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import RxSwift
import RxFlow
import RxRelay

protocol ListViewModelProtocol {
    associatedtype Item
    var items: PublishSubject<[Item]> { get set }
    func fetch(search: String, page: Int, perPage: Int)
}

struct ListViewModel: Stepper, ListViewModelProtocol {
    typealias Item = VideoListData
    var items = PublishSubject<[VideoListData]>()
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var steps = PublishRelay<Step>()
    
    func fetch(search: String, page: Int = 1, perPage: Int = 6) {
        isLoading.accept(true)
        Task {
            let response = try await Webservice().load(VideoList.resource(for: search, page: "\(page)", perPage: "\(perPage)"))
            isLoading.accept(false)
            switch response {
            case .success(let items):
                self.items.onNext(items.data ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func pick (video: VideoListData) {
        self.steps.accept(AppStep.showDetails(video: video))
    }
    
}
