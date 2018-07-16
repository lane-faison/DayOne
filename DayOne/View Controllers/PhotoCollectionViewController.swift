import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    var pictures: Results<Picture>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPictures()
    }
}

extension PhotoCollectionViewController {
    private func getPictures() {
        if let realm = try? Realm() {
            pictures = realm.objects(Picture.self)
            collectionView?.reloadData()
        }
    }
}

extension PhotoCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pictures = self.pictures {
            return pictures.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell {
            if let picture = pictures?[indexPath.row] {
                cell.imageView.image = picture.thumbnailImage()
                cell.dayLabel.text = picture.entry?.formattedDayString()
                cell.monthLabel.text = picture.entry?.formattedMonthYearString()
            }
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photoToDetail", sender: pictures?[indexPath.row].entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoToDetail" {
            if let entry = sender as? Entry {
                let detailVC = segue.destination as? JournalDetailViewController
                detailVC?.entry = entry
            }
        }
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width / 2)
    }
}
