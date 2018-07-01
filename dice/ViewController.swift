
import UIKit

struct FromTo {
    var from: Int
    var to: Int
}
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
    let ladderCells: [(from: Int, to: Int)] = [(4, 20), (12, 26), (29, 48), (41, 65), (52, 73), (57, 82), (70, 85), (90, 100), (92, 95)]
    let snakeCells: [(from: Int, to: Int)] = [(98, 23), (94, 67), (88, 46), (86, 53), (81, 44), (79, 61), (77, 55), (76, 13), (60, 15), (54, 1), (51, 30), (39, 5), (21, 17)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStartAlert()
        gameStarted()
    }
    
    // ladder cells: 4-20, 12-26, 29-48, 41-65, 52-73, 57-82, 70-85, 90-100, 92-95
    // snake cells: 98-23, 94-67, 88-46, 86-53, 81-44, 79-61, 77-55, 76-13, 60-15, 54-1, 51-30, 39-5, 21-17
    
    @IBAction func dicePressed(_ sender: UIButton) {
        let diceValue = rollDice()
        dice = Dice.init(rawValue: diceValue) ?? .none
        changeDiceImage()
        if player == .playerOne {
            configurePlayerOne(diceValue)
        } else {
            configurePlayerTwo(diceValue)
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
    
    func alertFunction(from: Int, to: Int, isLadder: Bool) {
        var title = "";var message = ""
        if isLadder {
            title = "Luck favors you"
            message = "You have climbed \(to - from) steps"
        } else {
            title = "Oops!"
            message = "You have climbed down by \(from - to) steps"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // this function is to configure the player one values
    fileprivate func configurePlayerOne(_ diceValue: Int) {
        playerOne.playerPosition += diceValue
        for ladderCell in ladderCells {
            if ladderCell.from == playerOne.playerPosition {
                // provide alert function
                alertFunction(from: ladderCell.from, to: ladderCell.to, isLadder: true)
                playerOne.playerPosition = ladderCell.to
            }
        }
        for snakeCell in snakeCells {
            if snakeCell.from == playerOne.playerPosition {
                // provide alert function
                alertFunction(from: snakeCell.from, to: snakeCell.to, isLadder: false)
                playerOne.playerPosition = snakeCell.to
            }
        }
        let boardPosition = view.viewWithTag(playerOne.playerPosition)
        boardPosition?.addSubview(playerOne.playerView)
        playerOneScoreLabel.text = "\(playerOne.playerPosition)"
        playerInfoLabel.text = playerOne.playerInfo
        player.changePlayer()
    }
    
    // this function of to configure the player two values
    fileprivate func configurePlayerTwo(_ diceValue: Int) {
        playerTwo.playerPosition += diceValue
        for ladderCell in ladderCells {
            if ladderCell.from == playerTwo.playerPosition {
                // provide alert function
                alertFunction(from: ladderCell.from, to: ladderCell.to, isLadder: true)
                playerTwo.playerPosition = ladderCell.to
            }
        }
        for snakeCell in snakeCells {
            if snakeCell.from == playerTwo.playerPosition {
                // provide alert function
                alertFunction(from: snakeCell.from, to: snakeCell.to, isLadder: false)
                playerTwo.playerPosition = snakeCell.to
            }
        }
        let boardPosition = view.viewWithTag(playerTwo.playerPosition)
        boardPosition?.addSubview(playerTwo.playerView)
        playerTwoScoreLabel.text = "\(playerTwo.playerPosition)"
        playerInfoLabel.text = playerTwo.playerInfo
        player.changePlayer()
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


















