import UIKit

class CreateJournalViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
