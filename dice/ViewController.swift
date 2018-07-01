
import UIKit

enum Dice: Int {
    case one = 1, two, three, four, five, six, none = 0
}
enum PlayerTurn {
    case playerOne, playerTwo
    mutating func changePlayer() {
        switch self {
        case .playerOne:
            self = .playerTwo
        case .playerTwo:
            self = .playerOne
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var playerInfoLabel: UILabel!
    @IBOutlet weak var diceButton: UIButton!
    @IBOutlet weak var diceButtonImage: UIImageView!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    
    var player: PlayerTurn = .playerOne
    let playerOne: Player = Player(playerInfo: "Player one's turn", playerColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))
    let playerTwo: Player = Player(playerInfo: "Player two's turn", playerColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
    var dice: Dice = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStartAlert()
        gameStarted()
    }
    @IBAction func dicePressed(_ sender: UIButton) {
        let diceValue = rollDice()
        dice = Dice.init(rawValue: diceValue) ?? .none
        changeDiceImage()
        if player == .playerOne {
            playerOne.playerPosition += diceValue
            let boardPosition = view.viewWithTag(playerOne.playerPosition)
            boardPosition?.addSubview(playerOne.playerView)
            playerOneScoreLabel.text = "\(playerOne.playerPosition)"
            playerInfoLabel.text = playerOne.playerInfo
            player.changePlayer()
        } else {
            playerTwo.playerPosition += diceValue
            let boardPosition = view.viewWithTag(playerTwo.playerPosition)
            boardPosition?.addSubview(playerTwo.playerView)
            playerTwoScoreLabel.text = "\(playerTwo.playerPosition)"
            playerInfoLabel.text = playerTwo.playerInfo
            player.changePlayer()
        }
    }
}


// helper functions
extension ViewController {
    func showStartAlert() {
        let alert = UIAlertController(title: "Snake And Ladder", message: "Let's Start", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Start", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gameStarted() {
        player = .playerOne
    }
    
    func rollDice() -> Int {
        return Int(arc4random() % 6) + 1
    }
    func changeDiceImage() {
        switch dice {
        case .one: diceButtonImage.image = UIImage(named: "dice_side_1.png")
        case .two: diceButtonImage.image = UIImage(named: "dice_side_2.png")
        case .three: diceButtonImage.image = UIImage(named: "dice_side_3.png")
        case .four: diceButtonImage.image = UIImage(named: "dice_side_4.png")
        case .five: diceButtonImage.image = UIImage(named: "dice_side_5.png")
        case .six: diceButtonImage.image = UIImage(named: "dice_side_6.png")
        default:
            break
        }
    }
}

class Player{
    var playerPosition: Int = 0
    let playerInfo: String
    var playerView: UIView
    init(playerInfo: String, playerColor: UIColor) {
        self.playerInfo = playerInfo
        self.playerView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        self.playerView.backgroundColor = playerColor
        self.playerView.layer.cornerRadius = self.playerView.frame.width / 2
        self.playerView.clipsToBounds = true
    }
}


















