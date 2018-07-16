import UIKit

class JournalDetailViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var journalTextLabel: UILabel!
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEntry()
    }
    
    private func setupEntry() {
        if let entry = self.entry {
            title = entry.formattedDateString()
            journalTextLabel.text = entry.text
            
            for picture in entry.pictures {
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                
                guard let fullImage = picture.fullImage() else { return }
                
                let ratio = fullImage.size.height / fullImage.size.width
                
                stackView.addArrangedSubview(imageView)
                
                imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0).isActive = true
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
                
                imageView.image = picture.fullImage()
            }
        } else {
            journalTextLabel.text = ""
        }
    }
}
