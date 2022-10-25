//
//  ListViewModel.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import Foundation
import RxSwift

protocol ListViewModelProtocol {
    associatedtype Item
    var items: PublishSubject<[Item]> { get set }
    func fetch()
}

struct ListViewModel: ListViewModelProtocol {
    
    typealias Item = VideoListItem
    var items = PublishSubject<[VideoListItem]>()
    
    func fetch() {
        Task {
            let response = try await Webservice().load(VideoListItem.resource())
            switch response {
            case .success(let items):
                self.items.onNext(items)
                self.items.onCompleted()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
