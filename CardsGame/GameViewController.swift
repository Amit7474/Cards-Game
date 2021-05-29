//
//  GameViewController.swift
//  CardsGame
//
//  Created by Amit Kremer  on 20/05/2021.
//

import UIKit
import CoreLocation



class GameViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var CounterLBL: UILabel!
    @IBOutlet weak var gameBoardView: UICollectionView!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var gameDurationLBL: UILabel!
    var stepsCounter = 0
    var gameDuration = 0
    var numOfPairs = 8
    var div = 4
    var isHardMode = false
    weak var timer: Timer?
    var latLng: LatLng!
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    let locationManager = CLLocationManager()
    let game = CardsGame()
    var cards = [Card]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        latLng = LatLng(lat: 0, lng: 0)
        if isHardMode{
            numOfPairs = 10
            div = 5
        }else{
            numOfPairs = 8
            div = 4
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

        
        game.delegate = self
        gameBoardView.dataSource = self
        gameBoardView.delegate = self
        gameBoardView.isScrollEnabled = false
        gameBoardView.isHidden = true
        gameBoardView.allowsSelection = true
        gameBoardView.backgroundColor = UIColor.clear
        
        
        CardsManager.instance.getCardImages(numOfPairs:numOfPairs) { (cardsArray, error) in
            if let _ = error {
            }
            
            self.cards = cardsArray!
            self.setupNewGame()
            self.onStartGame()
        }
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
        timer?.invalidate()
    }
    @objc func fireTimer() {
        gameDuration += 1
        gameDurationLBL?.text = convertSecondsToPrettyString()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latLng.lat = locValue.latitude
        latLng.lng = locValue.longitude
    }
    
    func convertSecondsToPrettyString() ->String {
        var minutes = 0
        var seconds = 0
        var minutesText = ""
        var secondsText = ""
        
        minutes = gameDuration % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = gameDuration % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        return "\(minutesText):\(secondsText)"
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            restartGame()
        }
    }
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        gameBoardView.reloadData()
        
    }
    
    func restartGame() {
        game.restartGame()
        
    }
    
    func startNewGame(){
        setupNewGame()
        onStartGame()
    }
    func onStartGame() {
        gameBoardView.isHidden = false
        stepsCounter = 0
        CounterLBL.text = "\(stepsCounter)"
        gameDuration = 0
    }
    
    func gameOverDialog(){
        let alertController = UIAlertController(
            title: "Card Game",
            message: "Want to play again?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "No", style: .cancel) {
            [weak self] (action) in
            self?.gameBoardView.isHidden = true
            self?.dismiss(animated: true, completion: nil)
        }
        let playAgainAction = UIAlertAction(
            title: "Yes", style: .default) {
            [weak self] (action) in
            self?.gameBoardView.isHidden = true
            self?.restartGame()
            self?.startNewGame()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) { }
    }
    func highScoreDialog() {
        let alert = UIAlertController(title: "", message: "Congrats! You set new high score!", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in textField.placeholder = "Please enter your name"}
        let name = alert.textFields![0]
        let saveNewHighScore = UIAlertAction(title: "Save high score", style: .default, handler: {(alert: UIAlertAction!) in
            
            self.addNewHighScore(name.text!)
            self.gameOverDialog()
            
        })
        alert.addAction(saveNewHighScore)
        self.present(alert, animated: true) {
            
            
        }
        
    }
    func addNewHighScore(_ name:String)  {
        let record = Record(gameDuration: gameDuration, Name: name, Location: latLng)
        ScoresManager.instance.addNewHighScore(record: record)
        
    }
}


extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
}


extension GameViewController: MemoryGameProtocol {
    func memoryGameDidStart(_ game: CardsGame) {
        gameBoardView.reloadData()
    }
    
    func memoryGame(_ game: CardsGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card)
            else { continue
            }
            
            let cell = gameBoardView.cellForItem(
                at: IndexPath(item: index, section:0)
            ) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    func memoryGame(_ game: CardsGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card)
            else { continue
            }
            
            let cell = gameBoardView.cellForItem(
                at: IndexPath(item: index, section:0)
            ) as! CardCell
            
            cell.showCard(false, animted: true)
        }
    }
    func memoryGameDidEnd(_ game: CardsGame) {
        if(ScoresManager.instance.isNewHighScore(gameDuration: gameDuration)){
            highScoreDialog()
        }else{
            gameOverDialog()

        }
        
        restartGame()
    }
    func memoryGamePairSelected(){
        stepsCounter = stepsCounter + 1
        self.CounterLBL.text = "\(stepsCounter)"
    }
}



extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = Int(sectionInsets.left) * div
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / div

        var res = CGSize(width: widthPerItem, height: widthPerItem)
        res.height = (collectionViewLayout.collectionView!.visibleSize.height / 4  - CGFloat(15))
        return res
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


