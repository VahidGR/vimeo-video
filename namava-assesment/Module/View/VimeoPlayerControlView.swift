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

class VimeoPlayerControlView: UIView {
    
    // properties
    weak var player: AVPlayer!
    var state = BehaviorRelay<RxPlayerState>(value: .Unknown)
    var isSeekInProgress = BehaviorRelay<Bool>(value: false)
    private let bag = DisposeBag()
    weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    // components
    private weak var stackView: UIStackView!
    private weak var playControl: UIImageView!
    private weak var progressBar: ProgressView!
    private weak var soundControl: UIImageView!
    weak var presentationControl: UIImageView!
    
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
        
        let stackView = UIStackView()
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = true
        let stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewHeightConstraint,
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        self.stackViewHeightConstraint = stackViewHeightConstraint
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 6
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let playControl = UIImageView()
        stackView.addArrangedSubview(playControl)
        NSLayoutConstraint.activate([
            playControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 22),
            playControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
        
        playControl.image = .init(systemImage: .play)?.withRenderingMode(.alwaysTemplate)
        playControl.contentMode = .scaleAspectFit
        playControl.tintColor = .darkGray
        
        self.playControl = playControl
        
        let progressBar = ProgressView()
        stackView.addArrangedSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -130),
            progressBar.heightAnchor.constraint(equalToConstant: 16)
        ])

        self.progressBar = progressBar
        
        let soundControlContainer = UIView()
        stackView.addArrangedSubview(soundControlContainer)
        NSLayoutConstraint.activate([
            soundControlContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
            soundControlContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
        
        let soundControl = UIImageView()
        soundControlContainer.addSubview(soundControl)
        soundControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            soundControl.leadingAnchor.constraint(equalTo: soundControlContainer.leadingAnchor, constant: 6),
            soundControl.trailingAnchor.constraint(equalTo: soundControlContainer.trailingAnchor),
            soundControl.topAnchor.constraint(equalTo: soundControlContainer.topAnchor),
            soundControl.bottomAnchor.constraint(equalTo: soundControlContainer.bottomAnchor),
        ])
        
        soundControl.image = .init(systemImage: .sound)?.withRenderingMode(.alwaysTemplate)
        soundControl.contentMode = .scaleAspectFit
        soundControl.tintColor = .darkGray
        
        self.soundControl = soundControl
        
        let presentationControl = UIImageView()
        stackView.addArrangedSubview(presentationControl)
        NSLayoutConstraint.activate([
            presentationControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 22),
            presentationControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
        
        presentationControl.image = .init(systemImage: .fullscreen)?.withRenderingMode(.alwaysTemplate)
        presentationControl.contentMode = .scaleAspectFit
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
                self.soundControl.image = .init(systemImage: .mute)
            } else {
                self.soundControl.image = .init(systemImage: .sound)
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
                self.playControl.image = .init(systemImage: .pause)
            case .Paused:
                self.player.pause()
                self.playControl.image = .init(systemImage: .play)
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
        
        let interval = CMTime(seconds: 0.016, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] elapsedTime in
            self?.updateVideoPlayerSlider()
        })
        
    }
    
}

// MARK: - Video progress slider value update
extension VimeoPlayerControlView {
    
    func updateVideoPlayerSlider() {
        
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
