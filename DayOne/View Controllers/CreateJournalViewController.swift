import UIKit

class CreateJournalViewController: UIViewController {
    
    let blueTheme = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.0) // #4CC1FC
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    @IBAction func setDateTapped(_ sender: Any) {
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
    }
}

extension CreateJournalViewController {
    private func setupView() {
        statusBarView.backgroundColor = blueTheme
        navBar.barTintColor = blueTheme
        navBar.tintColor = .white
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func changeKeyboardHeight(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyHeight = keyboardFrame.cgRectValue.height
        }
    }
    
    @objc private func keyboardWillHide() {
        
    }
    
    @objc private func keyboardWillShow() {
        
    }
}
