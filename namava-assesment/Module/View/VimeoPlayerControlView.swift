//
//  VimeoPlayerControlView.swift
//  namava-assesment
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import UIKit
import RxSwift
import RxRelay
import AVFoundation

class VimeoPlayerControlView: UIStackView {
    
    // properties
    weak var player: AVPlayer!
    var state = BehaviorRelay<RxPlayerState>(value: .Unknown)
    private let bag = DisposeBag()
    
    // components
    private weak var playControl: UIButton!
    private weak var progressBar: ProgressView!
    private weak var soundControl: UIButton!
    weak var presentationControl: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .lightGray
    }
    
    func setupControls() {
        setupView()
        createSubscriptions()
    }
    
}

// MARK: - UI configuration
extension VimeoPlayerControlView {
    
    private func setupView() {
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .top
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        isLayoutMarginsRelativeArrangement = true
        
        
        let playControl = UIButton()
        addArrangedSubview(playControl)
        NSLayoutConstraint.activate([
            playControl.widthAnchor.constraint(equalToConstant: 22),
            playControl.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        playControl.setImage(UIImage(systemName: "play.circle"), for: .normal)
        playControl.tintColor = .darkGray
        
        self.playControl = playControl
        
        let progressBar = ProgressView()
        addArrangedSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(equalTo: widthAnchor, constant: -112),
            progressBar.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        self.progressBar = progressBar
        
        let soundControl = UIButton()
        addArrangedSubview(soundControl)
        NSLayoutConstraint.activate([
            soundControl.widthAnchor.constraint(equalToConstant: 22),
            soundControl.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        soundControl.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        soundControl.tintColor = .darkGray
        
        self.soundControl = soundControl
        
        let presentationControl = UIButton()
        addArrangedSubview(presentationControl)
        NSLayoutConstraint.activate([
            presentationControl.widthAnchor.constraint(equalToConstant: 22),
            presentationControl.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        presentationControl.setImage(UIImage(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"), for: .normal)
        presentationControl.tintColor = .darkGray
        
        self.presentationControl = presentationControl
        
    }
    
}

// MARK: - Subscribe to events
extension VimeoPlayerControlView {
    
    private func createSubscriptions() {
        subscribePlayButtonGesture()
        subscribeSoundButtonGesture()
        subscibeToState()
        subscribeToPlayerStatus()
        addPlayerPeriodicTimeObserver()
    }
    
    private func subscribePlayButtonGesture() {
        
        playControl.rx.tapGesture().subscribe { [weak self] _ in
            guard let self = self,
                  let player = self.player
            else { return }
            
            if !player.isPlaying {
                self.state.accept(.Playing)
            } else {
                self.state.accept(.Paused)
            }
            
        }.disposed(by: bag)
        
    }
    
    private func subscribeSoundButtonGesture() {
        
        soundControl.rx.tapGesture().subscribe { [weak self] _ in
            guard let self = self,
                  let player = self.player
            else { return }
            
            if player.volume > 0 {
                player.volume = 0
                self.soundControl.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
            } else {
                self.soundControl.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
                player.volume = 0.5
            }
            
        }.disposed(by: bag)
        
    }
    
    private func subscibeToState() {
        
        state.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            
            switch value {
            case .Playing:
                self.player.play()
                self.playControl.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            case .Paused:
                self.player.pause()
                self.playControl.setImage(UIImage(systemName: "play.circle"), for: .normal)
            case .Failed:
                print("Failed")
            default:
                break
            }
            
        }).disposed(by: bag)
        
    }
    
    private func subscribeToPlayerStatus() {
        
        player.rx.status.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .unknown:
                self.state.accept(.Unknown)
            case .failed:
                self.state.accept(.Failed)
            case .readyToPlay:
                self.state.accept(.Playing)
            default:
                break
            }
        }).disposed(by: bag)
        
    }
    
    private func addPlayerPeriodicTimeObserver() {
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] elapsedTime in
            self?.updateVideoPlayerSlider()
        })
        
    }
    
}

// MARK: - Video progress slider value update
extension VimeoPlayerControlView {
    
    func updateVideoPlayerSlider() {
        guard let currentTime = player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        progressBar.setProgress(Float(currentTimeInSeconds), animated: false)
        if let currentItem = player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            let progress = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            progressBar.setProgress(progress, animated: false)
            
            if progress >= 1.0 {
                state.accept(.Paused)
                player.seek(to: .zero)
            }
            
            progressBar.setNeedsLayout()
        }
    }
    
}
