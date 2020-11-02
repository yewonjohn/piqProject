//
//  EventViewController.swift
//  piq
//
//  Created by John Kim on 11/1/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    //MARK:- Properties
    let backgroundImageView = UIImageView()
    let eventManager = EventManager()
    var listOfEvents = [EventModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServiceUtil().setBackground(view,backgroundImageView)
        configureCollectionView()
        getEvents()
        
    }
    
    func configureCollectionView(){
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.register(UINib(nibName:EventCell.identifier, bundle: nil), forCellWithReuseIdentifier:EventCell.identifier)

//        eventCollectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
    }
    
    func getEvents(){
        eventManager.getEvents(){ [weak self] (events) in
            DispatchQueue.main.async {
                self?.listOfEvents = events
                self?.eventCollectionView.reloadData()
                print(self?.listOfEvents)
            }
        }
    }
}
//MARK:- Collection View Datasource, delegate, and framing
extension EventViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    //datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        
        let currentEvent = listOfEvents[indexPath.row]
        
        let url = URL(string: currentEvent.image_url ?? "")
        cell.eventImage.kf.setImage(with: url)
        cell.eventTitle.text = currentEvent.name
        cell.eventDescription.text = currentEvent.description
        
        return cell
    }
    //framing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height * 0.45)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let url = URL(string: (listOfEvents[indexPath.row].event_site_url!) as! String) else { return }
        UIApplication.shared.open(url)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if(section == 2){
            return UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        }
        
       return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}


