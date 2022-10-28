//
//  VimeoPlayer.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/27/22.
//

import UIKit
import AVFoundation
import RxGesture
import RxSwift
import RxRelay

class VimeoPlayer: UIView {
    
    // properties
    weak var delegate: VideoContainable!
    private var bag = DisposeBag()
    var isFullscreen = BehaviorRelay<Bool>(value: false)
    private weak var controlHeightConstraint: NSLayoutConstraint!
    
    // control appearance managment
    private var timer: Timer?
    
    // componenets
    weak var thumbnail: VimeoThumbnail!
    weak var player: AVPlayer!
    weak var playerLayer: AVPlayerLayer!
    weak var controlView: VimeoPlayerControlView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = bounds
    }
    
    func addControlView() {
        
        let controlView = VimeoPlayerControlView()
        addSubview(controlView)
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        let controlHeightConstraint = controlView.heightAnchor.constraint(equalToConstant: 32)
        
        NSLayoutConstraint.activate([
            controlView.widthAnchor.constraint(equalTo: widthAnchor),
            controlHeightConstraint,
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor),
            controlView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        controlView.player = player
        controlView.setupControls()
        controlView.alpha = 0
        
        self.controlHeightConstraint = controlHeightConstraint
        self.controlView = controlView
        
        resetTimer()
        
    }
    
}

// MARK: - Valid video and UI configurations
extension VimeoPlayer {
    // setup video with URL and thumbnail
    func setupVideoPlayer(with url: String, thumbnailImage: UIImage?, duration: String?) {
        guard let url = URL(string: url) else {
            brokenURL(thumbnailImage: thumbnailImage)
            return
        }
        setupVideoPlayer(url: url)
        addControlView()
        createThumbnail(with: thumbnailImage, duration: duration)
        
        createSubscriptions()
    }
    
    private func setupVideoPlayer(url: URL) {
        
        let player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        
        let playerLayer = AVPlayerLayer(player: player)
        layer.addSublayer(playerLayer)
        
        self.player = player
        self.playerLayer = playerLayer
        
    }
    
    private func createThumbnail(with image: UIImage?, duration: String?) {
        
        let thumbnail = VimeoThumbnail()
        addSubview(thumbnail)
        
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.topAnchor.constraint(equalTo: topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        self.thumbnail = thumbnail
        
        thumbnail.setThumbnail(thumbnail: image, duration: duration)
        
    }
    
    // hide/show control view
    private func toggleControls() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.controlView.alpha = (self.controlView.alpha == 0) ? 1 : 0
        }
        resetTimer()
    }
    
}

// MARK: - Observations
extension VimeoPlayer {
    
    func createSubscriptions() {
        
        rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            self?.toggleControls()
        }.disposed(by: bag)
        
        controlView.presentationControl.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.isFullscreen.accept(!self.isFullscreen.value)
        }.disposed(by: bag)
        
        rx.pinchGesture().when(.began).subscribe { [weak self] _ in
            guard let self = self,
                  self.isFullscreen.value == false
            else { return }
            self.delegate.goFullscreen(player: self)
        }.disposed(by: bag)

        rx.swipeGesture([.down, .up]).when(.ended).subscribe { [weak self] _ in
            guard let self = self,
                  self.isFullscreen.value == true
            else { return }
            self.delegate.exitFullscreen(player: self)
        }.disposed(by: bag)
        
        thumbnail.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.controlView.state.accept(.Playing)
            self.thumbnail.isHidden = true
        }.disposed(by: bag)
        
        isFullscreen.asObservable().subscribe { [weak self] _ in
            guard let self = self else { return }
            let isBigger = self.isFullscreen.value
            
            switch isBigger {
            case true:
                self.delegate.goFullscreen(player: self)
                
//                self.controlView.grow()
                self.controlHeightConstraint.constant = 64
                UIView.animate(withDuration: 0.2) {
                    
                    self.controlView?.layoutIfNeeded()
                }
            case false:
                self.delegate.exitFullscreen(player: self)
//                self.controlView.shrink()
                self.controlHeightConstraint.constant = 32
                UIView.animate(withDuration: 0.2) {
                    
                    self.controlView?.layoutIfNeeded()
                }
            }
            
        }.disposed(by: bag)
        
    }
    
}

// MARK: - Bad URL
extension VimeoPlayer {
    
    func brokenURL(thumbnailImage: UIImage?) {
        
        let thumbnail = VimeoThumbnail()
        addSubview(thumbnail)
        
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.topAnchor.constraint(equalTo: topAnchor),
            thumbnail.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        self.thumbnail = thumbnail
        
        thumbnail.setThumbnail(thumbnail: thumbnailImage, isBroken: true, duration: nil)
        
    }
    
}

// MARK: - Control view hide/show automatically
extension VimeoPlayer {
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc func hideControls() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.controlView.alpha = 0
        }
    }
    
}

enum RxPlayerState {
    case Playing
    case Paused
    case Failed
    case Unknown
}
