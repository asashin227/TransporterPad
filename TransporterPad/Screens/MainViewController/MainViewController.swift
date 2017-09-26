//
//  ViewController.swift
//  TransporterPad
//
//  Created by Nobuhiro Ito on 2017/01/09.
//  Copyright © 2017年 Nobuhiro Ito. All rights reserved.
//

import Cocoa
import CoreFoundation
//import Alamofire

class MainViewController: NSViewController {
    @IBOutlet weak var dragTargetView: DragTargetView!
    @IBOutlet weak var collectionView: NSCollectionView!

    var viewModel: MainViewModel? {
        willSet {
            self.willChangeValue(forKey: "viewModel")
            
            guard let vm = viewModel else { return }
            vm.removeObserver(self, forKeyPath: "downloading")
            vm.removeObserver(self, forKeyPath: "progressValue")
        }
        didSet {
            self.didChangeValue(forKey: "viewModel")

            guard let vm = viewModel else { return }
            vm.addObserver(self, forKeyPath: "downloading", options: [.new], context: nil)
            vm.addObserver(self, forKeyPath: "progressValue", options: [.new], context: nil)
        }
    }
    
    var statusIndicatorVisible: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "statusIndicatorVisible")
        }
        didSet {
            self.didChangeValue(forKey: "statusIndicatorVisible")
        }
    }
    
    var progress: NSNumber = NSNumber(value: 0) {
        willSet {
            self.willChangeValue(forKey: "progress")
        }
        didSet {
            self.didChangeValue(forKey: "progress")
        }
    }
    
    var progressIntermediate: NSNumber = NSNumber(value: false) {
        willSet {
            self.willChangeValue(forKey: "progressIntermediate")
        }
        didSet {
            self.didChangeValue(forKey: "progressIntermediate")
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragTargetView.delegate = self
        collectionView.register(NSNib.init(nibNamed: "DeviceCollectionViewItem", bundle: nil), forItemWithIdentifier: "DeviceCollectionViewItem")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "downloading") {
            updateStatusIndicatorState()
        }
        if (keyPath == "progressValue") {
            updateStatusIndicatorState()
        }
    }
    
    func updateStatusIndicatorState() {
        guard let vm = viewModel else { return }
        statusIndicatorVisible = NSNumber(value: vm.downloading)
        progressIntermediate = NSNumber(value: vm.progressValue < 0)
        progress = NSNumber(value: vm.progressValue)
        
    }
}

extension MainViewController : DragTargetViewDelegate {

    func dragTargetView(_ dragTargetView: DragTargetView, dropRemoteURL fileName: String) {
        guard let vm = viewModel else { return }
        guard let url = URL(string: fileName) else { return }

        if !vm.dropRemoteItem(at: url, completeHandler: { result in
            if !result {
                // TODO: alert (ダウンロードしたファイルがipa/apkじゃなかった場合)
            }
        }, errorHandler: { err in
            // TODO: alert (ダウンロード失敗した場合)
        }) {
            // TODO: alert (ダウンロード開始できなかった場合)
        }
    }
    
    func dragTargetView(_ dragTargetView: DragTargetView, dropLocalFilePath fileName: String) {
        guard let vm = viewModel else { return }

        let fileURL = URL(fileURLWithPath: fileName)
        if !vm.dropLocalItem(at: fileURL) {
            // TODO: alert
        }
    }
}
