//
//  DetailViewController.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/27/22.
//

import UIKit
import RxSwift
import RxRelay
import HCVimeoVideoExtractor

protocol VideoContainable: AnyObject {
    var viewModel: DetailViewModel { get set }
    func goFullscreen(player: VimeoPlayer)
    func exitFullscreen(player: VimeoPlayer)
}

class DetailViewController: UIViewController, VideoContainable {
    
    // properties
    var viewModel = DetailViewModel()
    
    // components
    private weak var stackView: UIStackView!
    private weak var titleLabel: UILabel!
    private weak var player: VimeoPlayer!
    private weak var statsStackView: StatsStackView!
    private weak var descriptionLabel: UILabel!
    
    // player constraints for default and fullscreen appearances
    private lazy var playerCompactConstraints = [
        player.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        player.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 9/16)
    ]
    private lazy var playerFullscreenConstraints = [
        player.widthAnchor.constraint(equalTo: view.widthAnchor),
        player.heightAnchor.constraint(equalTo: view.heightAnchor),
        player.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        player.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uri = viewModel.video.uri, let url = URL(string: uri) {
            HCVimeoVideoExtractor.fetchVideoURLFrom(url: url) { [weak self] video, error in
                if error == nil, let videoURL = video?.videoURL[.Quality360p]?.absoluteString {
                    let duration = TimeFormatter().getTimeFormat(off: self?.viewModel.video.duration)
                    Task {
                        let image = try? await ImageLoader().fetch(video?.thumbnailURL[.Quality640]?.absoluteString)
                        self?.player.setupVideoPlayer(with: videoURL, thumbnailImage: image, duration: duration)
                    }
                } else {
                    Task {
                        let image = try? await ImageLoader().fetch(video?.thumbnailURL[.Quality640]?.absoluteString)
                        self?.player.brokenURL(thumbnailImage: image)
                    }
                }
            }
        }
        
    }
    
}

// MARK: - UI configurations
extension DetailViewController {
    
    private func setupViews() {
        
        let stackView = UIStackView()
        view.addSubview(stackView)
        self.stackView = stackView
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.9),
            stackView.heightAnchor.constraint(equalTo: guide.heightAnchor),
            stackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.alignment = .center
        
        let titleLabel = UILabel()
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.text = viewModel.video.name
        titleLabel.textAlignment = .center
        
        let player = VimeoPlayer()
        stackView.addArrangedSubview(player)
        self.player = player
        
        NSLayoutConstraint.activate(playerCompactConstraints)
        
        player.delegate = self
        player.accessibilityIdentifier = "vimeo-player"
        
        let statsStackView = StatsStackView()
        stackView.addArrangedSubview(statsStackView)
        
        NSLayoutConstraint.activate([
            statsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            statsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if statsStackView.configureStats(plays: viewModel.video.stats?.plays,
                                         likes: viewModel.video.metadata?.connections?.likes?.total,
                                         comments: viewModel.video.metadata?.connections?.comments?.total) == false {
            statsStackView.isHidden = true
        }

        let descriptionLabel = UILabel()
        stackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.text = viewModel.video.description
        
        
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        
    }
    
}

// MARK: - Manage player appearances
extension DetailViewController {
    
    func goFullscreen(player: VimeoPlayer) {
        
        player.removeConstraints(playerCompactConstraints)
        stackView.removeArrangedSubview(player)
        
        view.addSubview(player)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            NSLayoutConstraint.activate(self.playerFullscreenConstraints)
            player.backgroundColor = .black
            
        }
        
    }
    
    func exitFullscreen(player: VimeoPlayer) {
        
        player.removeFromSuperview()
        player.removeConstraints(playerFullscreenConstraints)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.stackView.insertArrangedSubview(player, at: 1)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            NSLayoutConstraint.activate(self.playerCompactConstraints)
            player.backgroundColor = .clear
            
        }
        
    }
    
}
