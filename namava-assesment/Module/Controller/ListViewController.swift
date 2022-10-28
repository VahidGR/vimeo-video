//
//  ListViewController.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/25/22.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    
    // properties
    var viewModel = ListViewModel()
    var authenticationViewModel = AuthenticationViewModel()
    private var bag = DisposeBag()
    private let cellIdentifier = "list-item"
    
    // components
    private weak var stackView: UIStackView!
    private weak var searchBar: UISearchBar!
    private weak var collectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        
        setupStackView()
        setupSearchBar()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeLoadingIndicator()
        subscribeErrorAlert()
        
        authenticationViewModel.configureVimeo { [weak self] in
            self?.bindCollectionData()
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
                cell.titleLabel.text = model.name
                cell.descriptionLabel.text = model.description
                cell.durationLabel.text = TimeFormatter().getTimeFormat(off: model.duration)
                Task {
                    cell.imageView.image = try? await ImageLoader().fetch(model.pictures?.base_link)
                }
            }
        }.disposed(by: bag)
        
        // bind a model selected handler
        collectionView.rx.modelSelected(VideoListData.self).bind { [weak self] video in
            self?.viewModel.pick(video: video)
        }.disposed(by: bag)
        
    }
    
}

// MARK: - UI configurations
extension ListViewController {
    
    func setupStackView() {
        
        let stackView = UIStackView()
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: guide.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: guide.heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.stackView = stackView
        
    }
    
    func setupSearchBar() {
        
        let searchBar = UISearchBar()
        stackView.addArrangedSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        searchBar.searchTextField.delegate = self
        
        self.searchBar = searchBar
        
    }
    
    func setupCollectionView() {
        
        let itemWidth = view.bounds.size.width - 40
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.24)
        flowLayout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        stackView.addArrangedSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -50)
        ])
        
        collectionView.register(ListItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .clear
        
        self.collectionView = collectionView
        
    }
    
}

// MARK: - Fetch items on return key pressed
extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        // fetch items
        if let query = textField.text {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.viewModel.fetch(search: query)
            }
        }
        return false
    }
    
}

// MARK: - Subscribe to networking events
extension ListViewController {
    
    private func subscribeErrorAlert() {
        
        authenticationViewModel.error.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch self.authenticationViewModel.error.value {
                case .some(let message):
                    self.presentAlert(message: message, actionText: "Retry") {
                        self.authenticationViewModel.configureVimeo {
                            self.bindCollectionData()
                        }
                    }
                case .none:
                    break
                }
            }
            
        }.disposed(by: bag)
        
        viewModel.error.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch self.viewModel.error.value {
                case .some(let message):
                    self.presentAlert(message: message, actionText: "Okay")
                case .none:
                    break
                }
            }
            
        }.disposed(by: bag)
        
    }
    
    private func subscribeLoadingIndicator() {
        
        viewModel.isLoading.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch self.viewModel.isLoading.value {
                case true:
                    self.view.startLoadingIndicator()
                case false:
                    self.view.stopLoadingIndicator()
                }
            }
            
        }.disposed(by: bag)
        
    }
    
}

