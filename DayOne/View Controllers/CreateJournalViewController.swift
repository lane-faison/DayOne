import UIKit
import RealmSwift
import Spring

public let blueTheme = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.0) // #4CC1FC

class CreateJournalViewController: UIViewController {
    
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private var imagePicker = UIImagePickerController()
    private var images: [UIImage] = []
    var startWithCamera = false
    var entry = Entry()
    
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
            entry.text = journalTextView.text
            
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
        entry.date = datePicker.date
        updateDate()
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
        journalTextView.isHidden = true
        datePicker.isHidden = false
        setDateButton.isHidden = false
        datePicker.date = entry.date
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
        navBar.topItem?.title = entry.formattedDateString()
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
            let imageView = SpringImageView()
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 70.0),
                imageView.widthAnchor.constraint(equalToConstant: 70.0)
                ])
            
            imageView.image = chosenImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            imagePicker.dismiss(animated: true) {
                imageView.animation = "pop"
                imageView.duration = 2.0
                imageView.animate()
            }
        }
    }
}
