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
    var eventImageMapping = [String:UIImage]()
//    var eventImages = [UIImage]()
    var imageLoadedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = eventCollectionView?.collectionViewLayout as? EventsLayout {
            layout.delegate = self
        }
        
        ServiceUtil().setBackground(view,backgroundImageView)
        configureCollectionView()
        getEvents()
        
    }
    
    func configureCollectionView(){
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.register(UINib(nibName:EventCell.identifier, bundle: nil), forCellWithReuseIdentifier:EventCell.identifier)
    }
    
    func getEvents(){
        eventManager.getEvents(){ [weak self] (events) in
            
            self?.listOfEvents = events
            if let listEvents = self?.listOfEvents {
                for event in listEvents{
                    let url = URL(string: event.image_url ?? "")
                    guard let url1 = url else {continue}
                    self?.downloadImage(from: url1, numOfImages: listEvents.count, eventId: event.id ?? "")
                }
            }
        }
    }
    func getData(from url: URL, numOfImages: Int, eventId: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, numOfImages: Int, eventId: String) {
        getData(from: url, numOfImages: numOfImages, eventId: eventId) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageLoadedCount += 1
                self?.eventImageMapping[eventId] = UIImage(data: data) ?? UIImage()
                
                if(self?.imageLoadedCount == numOfImages){
                    self?.eventCollectionView.reloadData()
                }
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
        cell.clipsToBounds = true
        
        let currentEvent = listOfEvents[indexPath.row]
        
        if let id = currentEvent.id{
            cell.eventImage.image = eventImageMapping[id]
        }
        cell.eventTitle.text = currentEvent.name
        cell.eventDescription.text = currentEvent.description
        
        //        if(indexPath.row == 2){
        //            let layout = UICollectionViewFlowLayout()
        //            layout.sectionInset = UIEdgeInsets(top: 100, left: 20, bottom: 0, right: 20)
        //
        //            collectionView.collectionViewLayout = layout
        //        }
        
        
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
        
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }
    
}

//MARK:- CollectionView Layout Custom Delegate (sending current image's height)
extension EventViewController: EventsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {

        let event = listOfEvents[indexPath.row]
        let image = eventImageMapping[event.id ?? ""]
        guard var height = image?.size.height else {return 300}
        
        switch height {
        case 0..<500:
            height = 300
        case 500..<1000:
            height = height/3
        case 1000..<2000:
            height = height/5
        default:
            height = 300
        }
        
        return height
    }
}
