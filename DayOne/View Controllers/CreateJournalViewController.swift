import UIKit
import RealmSwift

class CreateJournalViewController: UIViewController {
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private let blueTheme = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.0) // #4CC1FC
    
    private var date = Date()
    private var imagePicker = UIImagePickerController()
    private var images: [UIImage] = []
    var startWithCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if startWithCamera {
            startWithCamera = !startWithCamera
            cameraTapped("")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let realm = try? Realm() {
            let entry = Entry()
            entry.text = journalTextView.text
            entry.date = date
            
            for image in images {
                let picture = Picture(image: image)
                entry.pictures.append(picture)
                picture.entry = entry
            }
            
            try? realm.write {
                realm.add(entry)
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func setDateTapped(_ sender: Any) {
        journalTextView.isHidden = false
        datePicker.isHidden = true
        setDateButton.isHidden = true
        date = datePicker.date
        updateDate()
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
        journalTextView.isHidden = true
        datePicker.isHidden = false
        setDateButton.isHidden = false
        datePicker.date = date
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
    
    private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d, yyyy"
        navBar.topItem?.title = dateFormatter.string(from: date)
    }
    
    private func changeKeyboardHeight(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyHeight = keyboardFrame.cgRectValue.height
            
            bottomConstraint.constant = keyHeight + 10
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        changeKeyboardHeight(notification: notification)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        changeKeyboardHeight(notification: notification)
    }
}

extension CreateJournalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(chosenImage)
            // Animation
            let imageView = UIImageView()
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 70.0),
                imageView.widthAnchor.constraint(equalToConstant: 70.0)
                ])
            
            imageView.image = chosenImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            imagePicker.dismiss(animated: true) {
                // Animation
            }
        }
    }
}
