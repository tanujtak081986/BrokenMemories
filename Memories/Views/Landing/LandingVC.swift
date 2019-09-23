//
//  ViewController.swift
//  Memories
//
//  Created by tanuj tak on 5/9/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import UIKit
import UserNotifications

class LandingVC: UIViewController {

    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var lblNoData : DesignableLabel!
    @IBOutlet weak var loaderBgView: UIView!
    
    private var viewModel : LandingViewModel = LandingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        loadData()
        setupObservers()
        viewModel.setListnerForLocalNotificationTrigger()
    }
    
    private func setup() {
        cardsCollectionView.register(R.nib.cardCollectionViewCell)        
    }
    
    @objc
    private func loadData() {
        //get card for current sequence number to be displayed.
        guard let sequenceNo = UserDefaults.standard.value(forKey: AppStrings.Keys.sequence) as? Int else {
            fatalError("No sequence number found. Check userdefaults")
        }
        
        viewModel.downloadCards {
            
            self.viewModel.loadCardForSequence("\(sequenceNo)")
            guard self.viewModel.memoryCards.count > 0 else {
                //NO CARDS AVAILABLE. DISPLAY MESSAGE
                defer {
                    self.noDataUIHandler()
                }
                self.viewModel.resetData()
                return
            }
            self.cardsCollectionView.reloadData()
            
            if self.viewModel.memoryCards.count > 0 {
                //as we are sure the count is greater than 0, we can force unwrap the first card from the list.
                self.viewModel.didDisplayCard(self.viewModel.memoryCards.first!)
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .notificationTriggered, object: nil)
        
        //The data reset trigger field is set from the firebase backend database. Reset everything if the key is found to be valid.
        viewModel.shouldRefreshViewOnDataReset = {
            if UserDefaults.standard.value(forKey: AppStrings.Keys.sequence) == nil {
                UserDefaults.standard.setValue(0, forKey: AppStrings.Keys.sequence)
            }
            self.loadData()
        }
    }
    
    //Display no data available 
    private func noDataUIHandler() {
        cardsCollectionView.isHidden = true
        lblNoData.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension LandingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memoryCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        cell.card = viewModel.memoryCards[indexPath.row] //configure cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SwifterSwift.screenWidth, height: SwifterSwift.screenHeight)
    }
}
