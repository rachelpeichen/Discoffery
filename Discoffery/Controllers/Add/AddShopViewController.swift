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
  
  var wrappedNewShop = NewCoffeeShop()

  var parsedOpenHours: String?

  var addedItem: String?

  var uploadedImgArr: [UIImage] = []

  var uploadedImgURLArr: [String] = []

  // MARK: - IBOutlets
  @IBOutlet weak var timeSegControl: UISegmentedControl!
  @IBOutlet weak var socketSegControl: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var addItemTextField: UITextField!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var notesTextView: UITextView!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in
        
        self.wrappedNewShop.rating = rating
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

    if let inputName = sender.text {
      wrappedNewShop.newShopName = inputName
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

    if let input = sender.text {

      if !input.isEmpty {
        addedItem = input
      }
    }
  }

  @IBAction func onTapAddItemBtn(_ sender: UIButton) {

    guard let addedItem = addedItem else { return }

    wrappedNewShop.recommendItems.append(addedItem)
    addItemTextField.text = ""
    collectionView.reloadData()
  }

  @IBAction func onTapUploadImageBtn(_ sender: Any) {

    setUpImagesPicker()
  }

  @IBAction func onTapSendBtn(_ sender: Any) {

    sendNewShop(newShop: &wrappedNewShop  )
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

  // MARK: - Private Functions
  private func layoutAddShopVC() {

    sendBtn.isEnabled = false

    commentTextView.delegate           = self
    commentTextView.layer.borderWidth  = 0.5
    commentTextView.layer.borderColor  = UIColor.B5?.cgColor
    commentTextView.clipsToBounds      = true
    commentTextView.layer.cornerRadius = 10

    notesTextView.delegate             = self
    notesTextView.layer.borderWidth    = 0.5
    notesTextView.layer.borderColor    = UIColor.B5?.cgColor
    notesTextView.clipsToBounds        = true
    notesTextView.layer.cornerRadius   = 10
  }

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: AddItemCollectionViewCell.identifier, bundle: nil),
                            forCellWithReuseIdentifier: AddItemCollectionViewCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  // MARK: - Functions
  func sendNewShop(newShop: inout NewCoffeeShop) {

    var localNewShop = newShop

    let dispatchGroup = DispatchGroup()

    for index in 0..<self.uploadedImgArr.count {

      dispatchGroup.enter()

      self.addViewModel.uploadImageFromUser(with: self.uploadedImgArr[index], folderName: "newShopImgs")

      self.addViewModel.onUploadImage = { result in

        self.uploadedImgURLArr.append(result)

        dispatchGroup.leave()
      }
    }

    dispatchGroup.notify(queue: .main) {

      self.addViewModel.publishNewShop(newShop: &localNewShop, uploadedImgURL: self.uploadedImgURLArr)

      self.showSuccessHUD(showInfo: "新增咖啡廳資訊成功")

      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {

        self.showAddShopSuccessDialog()
      }
    }
  }
}

// MARK: - AddOpenHoursViewControllerDelegate
extension AddShopViewController: AddOpenHoursViewControllerDelegate {

  func finishAddOpenHours(openHours: [String: Any?]) {

    let openHoursDic = openHours.compactMapValues { $0 }

    parsedOpenHours = (openHoursDic.compactMap({ key, value -> String in

      return "\(key): \(value)"
    }) as Array).joined(separator: ";")

    wrappedNewShop.openHours = parsedOpenHours ?? "Unknown"
    sendBtn.isEnabled = true
    sendBtn.backgroundColor = .B3
  }
}

// MARK: - UICollectionViewDataSource
extension AddShopViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return wrappedNewShop.recommendItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddItemCollectionViewCell.identifier,
                                                     for: indexPath) as? AddItemCollectionViewCell {
      cell.layoutAddItemCollectionViewCell(from: wrappedNewShop.recommendItems[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddShopViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = wrappedNewShop.recommendItems[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 60, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

    return 8
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if collectionView.dequeueReusableCell(withReuseIdentifier: AddItemCollectionViewCell.identifier,
                                          for: indexPath) is AddItemCollectionViewCell {
      wrappedNewShop.recommendItems.remove(at: indexPath.row)
      collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension AddShopViewController: UICollectionViewDelegate {
}

// MARK: - UITextViewDelegate
extension AddShopViewController: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    if textView == commentTextView {
      wrappedNewShop.comment = textView.text

    } else {
      wrappedNewShop.notes = textView.text
    }
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
        imgOne.isHidden        = false
        imgTwo.isHidden        = false
        imgThree.isHidden      = false
        imgOne.image           = uploadedImgArr[0]
        imgTwo.image           = uploadedImgArr[1]
        imgThree.image         = uploadedImgArr[2]
        uploadImgBtn.isEnabled = false
        uploadImgBtn.setTitleColor(.lightGray, for: .disabled)

      default:
        print("Default Case")
      }
    }
  }
}
