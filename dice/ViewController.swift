
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
    let playerTwo: Player = Player(playerInfo: "Player two's turn", playerColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), view: UIView(frame: CGRect(x: 4, y: 4, width: 15, height: 15)))
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

    fileprivate func diceButtonPressedFunction() {
        let diceValue = rollDice()
        dice = Dice.init(rawValue: diceValue) ?? .none
        changeDiceImage()
        if player == .playerOne {
            configurePlayerOne(diceValue)
        } else {
            configurePlayerTwo(diceValue)
        }
    }
    
    @IBAction func dicePressed(_ sender: UIButton) {
        diceRollRamdom()
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
        diceButtonImage.image = UIImage(named: "startButton.png")
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
    
    func winningAlertAndReset(isPlayerOne: Bool) {
        var player = ""
        if isPlayerOne {
            player = "Player one"
        } else {
            player = "Player two"
        }
        let alert = UIAlertController(title: "Victory", message: "\(player) has won the game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in
            self.resetGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func overflowAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Cannot go beyond 100\nPlay next turn", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func resetGame() {
        // reset the game in here
        self.playerTwo.playerPosition = 0
        self.playerOne.playerPosition = 0
        let view = self.view.viewWithTag(0)
        view?.addSubview(self.playerTwo.playerView)
        view?.addSubview(self.playerOne.playerView)
        self.playerInfoLabel.text = "Start the game"
        self.playerTwoScoreLabel.text = "0"
        self.playerOneScoreLabel.text = "0"
        self.player = .playerOne
    }
    
    // this function is to configure the player one values
    fileprivate func configurePlayerOne(_ diceValue: Int) {
        playerOne.playerPosition += diceValue
        if playerOne.playerPosition == 100 {
            winningAlertAndReset(isPlayerOne: true)
        } else if playerOne.playerPosition > 100 {
            overflowAlert()
            playerOne.playerPosition -= diceValue
        }
        for ladderCell in ladderCells {
            if ladderCell.from == playerOne.playerPosition {
                // provide alert function
                alertFunction(from: ladderCell.from, to: ladderCell.to, isLadder: true)
                playerOne.playerPosition = ladderCell.to
                if playerOne.playerPosition == 100 {
                    winningAlertAndReset(isPlayerOne: true)
                }
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
        playerInfoLabel.text = playerTwo.playerInfo
        player.changePlayer()
    }
    
    // this function of to configure the player two values
    fileprivate func configurePlayerTwo(_ diceValue: Int) {
        playerTwo.playerPosition += diceValue
        if playerTwo.playerPosition == 100 {
            winningAlertAndReset(isPlayerOne: false)
        } else if playerTwo.playerPosition > 100 {
            overflowAlert()
            playerTwo.playerPosition -= diceValue
        }
        for ladderCell in ladderCells {
            if ladderCell.from == playerTwo.playerPosition {
                // provide alert function
                alertFunction(from: ladderCell.from, to: ladderCell.to, isLadder: true)
                playerTwo.playerPosition = ladderCell.to
                if playerOne.playerPosition == 100 {
                    winningAlertAndReset(isPlayerOne: false)
                }
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
        playerInfoLabel.text = playerOne.playerInfo
        player.changePlayer()
    }
    
    func diceRollRamdom() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(randomDiceChanger), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            timer.invalidate()
            self.diceButtonPressedFunction()
        })
    }
    
    @objc func randomDiceChanger() {
        let randomNumber = Int(arc4random() % 6) + 1
        switch randomNumber {
        case 1: diceButtonImage.image = UIImage(named: "dice_side_1.png")
        case 2: diceButtonImage.image = UIImage(named: "dice_side_2.png")
        case 3: diceButtonImage.image = UIImage(named: "dice_side_3.png")
        case 4: diceButtonImage.image = UIImage(named: "dice_side_4.png")
        case 5: diceButtonImage.image = UIImage(named: "dice_side_5.png")
        case 6: diceButtonImage.image = UIImage(named: "dice_side_6.png")
        default:
            break
        }
    }
}

class Player{
    var playerPosition: Int = 0
    let playerInfo: String
    var playerView: UIView
    
    init(playerInfo: String, playerColor: UIColor, view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))) {
        self.playerInfo = playerInfo
        self.playerView = view
        self.playerView.backgroundColor = playerColor
        self.playerView.layer.cornerRadius = self.playerView.frame.width / 2
        self.playerView.clipsToBounds = true
    }
}


