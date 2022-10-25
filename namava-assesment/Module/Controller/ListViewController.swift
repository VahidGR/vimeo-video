//
//  ListViewController.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    
    // properties
    private var viewModel = ListViewModel()
    private var bag = DisposeBag()
    private let cellIdentifier = "list-item"
    
    // components
    private weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetch()
        }
        
    }
    
    private func bindCollectionData() {
        // bind items to collection
        viewModel.items.bind(
            to: collectionView.rx.items(
                cellIdentifier: cellIdentifier,
                cellType: ListItemCell.self)
        ) { row, model, cell in
            DispatchQueue.main.async {
                Task {
                    cell.imageView.image = try await ImageLoader().fetch(model.thumbnail)
                    cell.titleLabel.text = model.name
                }.cancel()
            }
        }.disposed(by: bag)
        
        // bind a model selected handler
        collectionView.rx.modelSelected(VideoListItem.self).bind { video in
            print(video.name)
        }.disposed(by: bag)
        
        // fetch items
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.viewModel.fetch()
        }
    }
    
}

extension ListViewController {
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: view.bounds.size.width - 40, height: view.bounds.size.height / 5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // activate constraints
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
        collectionView.register(ListItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        self.collectionView = collectionView
    }
    
}
