//
//  AddShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import PopupDialog
import YPImagePicker
import Cosmos

class AddShopViewController: UIViewController {

  // MARK: - Properties
  var addViewModel = AddViewModel()
  
  var wrappedNewShop = CoffeeShop()

  var wrappedNewShopReview = Review()

  var wrappedNewShopRecommendItem = RecommendItem()

  var wrappedNewShopFeature = Feature()

  var parsedOpenHours: String?

  var uploadedImgArr: [UIImage] = []

  // MARK: - Outlets

  @IBOutlet weak var timeSegControl: UISegmentedControl!

  @IBOutlet weak var socketSegControl: UISegmentedControl!

  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var nameTextField: UITextField!

  @IBOutlet weak var addressTextField: UITextField!

  @IBOutlet weak var addItemTextField: UITextField!

  @IBOutlet weak var commentTextView: UITextView!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in
        
        self.wrappedNewShopReview.rating = rating
      }
    }
  }

  @IBOutlet weak var uploadImgBtn: UIButton!

  @IBOutlet var sendBtn: UIButton!

  @IBOutlet weak var imgOne: UIImageView!

  @IBOutlet weak var imgTwo: UIImageView!

  @IBOutlet weak var imgThree: UIImageView!

  // MARK: - IBActions
  @IBAction func endEditShopName(_ sender: UITextField) {

    if let name = sender.text {

      wrappedNewShop.name = name
    }
  }

  @IBAction func endEditAddress(_ sender: UITextField) {

    if let address = sender.text {

      wrappedNewShop.address = address
    }
  }

  @IBAction func navigateToAddOpenHoursVC(_ sender: Any) {

    performSegue(withIdentifier: "OpenHoursVCSegue", sender: self)
  }

  @IBAction func didEndAddItemText(_ sender: UITextField) {

    if let addedItem = sender.text {

      wrappedNewShopReview.recommendItems.append(addedItem)
    }
  }

  @IBAction func onTapAddItemBtn(_ sender: UIButton) {

    addItemTextField.text = ""

    collectionView.reloadData()
  }

  @IBAction func onTapUploadImageBtn(_ sender: Any) {

    setUpImagesPicker()
  }

  @IBAction func onTapSendBtn(_ sender: Any) {

    addViewModel.publishNewShop(shop: &wrappedNewShop)

    showAddShopSuccessDialog()
  }

  @IBAction func backToMainPage(_ sender: UIBarButtonItem) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Segue to AddOpenHoursVC
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "OpenHoursVCSegue" {

      if let destinationVC = segue.destination as? AddOpenHoursViewController {

        destinationVC.delegate = self
      }
    }
  }
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    layoutAddShopVC()

    setupCollectionView()
  }

  // MARK: - Layout Style
  private func layoutAddShopVC() {

    sendBtn.isEnabled = false

    commentTextView.delegate           = self
    commentTextView.layer.borderWidth  = 0.5
    commentTextView.layer.borderColor  = UIColor.B5?.cgColor
    commentTextView.clipsToBounds      = true
    commentTextView.layer.cornerRadius = 10
  }

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "AddItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addItemCollectionViewCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }
}

// MARK: - AddOpenHoursViewControllerDelegate
extension AddShopViewController: AddOpenHoursViewControllerDelegate {

  func finishAddOpenHours(openHours: [String: Any?]) {

    let openHoursDic = openHours.compactMapValues { $0 }

    parsedOpenHours = (openHoursDic.compactMap({ (key, value) -> String in

      return "\(key): \(value)"

    }) as Array).joined(separator: ";")

    wrappedNewShop.openTime = parsedOpenHours ?? "Unknown"

    sendBtn.isEnabled = true

    sendBtn.backgroundColor = .B3
  }
}

// MARK: - UICollectionViewDataSource
extension AddShopViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return wrappedNewShopReview.recommendItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) as? AddItemCollectionViewCell {

      cell.layoutAddItemCollectionViewCell(from: wrappedNewShopReview.recommendItems[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddShopViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize =  wrappedNewShopReview.recommendItems[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 60, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

    return 8
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) is AddItemCollectionViewCell {

      wrappedNewShopReview.recommendItems.remove(at: indexPath.row)

      collectionView.reloadData()
    }
  }
}

extension AddShopViewController: UICollectionViewDelegate {
}

// MARK: - UITextViewDelegate
extension AddShopViewController: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    wrappedNewShopReview.comment = textView.text
  }
}

// MARK: - YPImagePicker
extension AddShopViewController {

  func setUpImagesPicker() {

    var config = YPImagePickerConfiguration()

    config.library.maxNumberOfItems = 3

    config.startOnScreen = .library

    let picker = YPImagePicker(configuration: config)

    present(picker, animated: true, completion: nil)

    picker.didFinishPicking { [unowned picker] items, cancelled in

      if cancelled {

        picker.dismiss(animated: true, completion: nil)

      } else {

        self.showSuccessHUD(showInfo: "上傳照片成功")

        for item in items {

          switch item {

          case .photo(let photo):

            self.uploadedImgArr.append(photo.image)

            self.layoutUploadImgs()

          case .video(let video):

            print("You can't upload video lmao \(video)")
          }
        }
        picker.dismiss(animated: true, completion: nil)
      }
    }
  }

  func layoutUploadImgs() {

    uploadImgBtn.isEnabled = true

    if !uploadedImgArr.isEmpty {

      switch uploadedImgArr.count {

      case 1:
        imgOne.isHidden = false
        imgOne.image    = uploadedImgArr[0]

      case 2:
        imgOne.isHidden = false
        imgTwo.isHidden = false
        imgOne.image    = uploadedImgArr[0]
        imgTwo.image    = uploadedImgArr[1]

      case 3:
        imgOne.isHidden    = false
        imgTwo.isHidden    = false
        imgThree.isHidden  = false
        imgOne.image       = uploadedImgArr[0]
        imgTwo.image       = uploadedImgArr[1]
        imgThree.image     = uploadedImgArr[2]
        uploadImgBtn.isEnabled = false
        uploadImgBtn.setTitleColor(.lightGray, for: .disabled)

      default:
        print("nononono")
      }
    }
  }
}
