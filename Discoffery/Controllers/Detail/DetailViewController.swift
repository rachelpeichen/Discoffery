//
//  DetailViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import JGProgressHUD
import YPImagePicker

class DetailViewController: UIViewController {
  
  // MARK: - Properties
  var addViewModel = AddViewModel()

  var collectionViewModel = CollectionViewModel()

  var shop: CoffeeShop?

  var shopName = "Cafe Name"

  var reviews: [Review] = []

  var reviewsCount = 0

  var feature = Feature()

  var recommendItemsArr: [RecommendItem] = []

  var uploadedImgArr: [UIImage] = []

  var uploadedImgURLArr: [String] = []

  var isSavedInUserCollection = true

  private let shopsDetail: [CoffeeShopContentCategory] =
    [.images, .description, .recommend, .feature, .route, .writeReview]

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var saveButton: UIButton!

  // MARK: - IBActions
  @IBAction func onTapBackButton(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  let activityVC = UIActivityViewController(activityItems: ["跟你分享一家很棒的咖啡廳😊"], applicationActivities: nil)

  @IBAction func onTapShareButton(_ sender: Any) {

    present(activityVC, animated: true, completion: nil)
  }

  @IBAction func saveToCollection(_ sender: UIButton) {

    syncSavedShopToCollectionStatus()

    if isSavedInUserCollection {

      removeSavedShopInCollection()
      collectionViewModel.onRemoveShopFromDefaultCategory = {
        self.showSuccessHUD(showInfo: "成功取消收藏")
        sender.isSelected = false
      }

    } else {

      saveShopToCollection()
      collectionViewModel.onAddUserSavedShop = {
        self.showSuccessHUD(showInfo: "成功加入收藏")
        sender.isSelected = true
      }
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()

    if let shop = shop {
      fetchReviewsForShop(shop: shop)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    syncSavedShopToCollectionStatus()
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let reviewsVC = segue.destination as? ReviewsPageViewController {

      reviewsVC.reviews = self.reviews
      reviewsVC.shopName = self.shopName

    } else if let mapVC = segue.destination as? MapRouteViewController {

      mapVC.shopName = self.shopName

      if let shop = shop {

        mapVC.shopLocation.latitude = shop.latitude
        mapVC.shopLocation.longitude = shop.longitude
      }
    }
  }

  func fetchReviewsForShop(shop: CoffeeShop) {

    ReviewManager.shared.fetchReviewsForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getReviews):
        self?.reviews = getReviews
        self?.reviews.sort(by: { $0.postTime > $1.postTime })
        self?.reviewsCount = getReviews.count
        self?.tableView.reloadData()

      case .failure(let error):
        print("fetchReviewsForShop: \(error)")
      }
    }
  }

  func syncSavedShopToCollectionStatus() {

    collectionViewModel.fetchSavedShopsInDefaultCategory(user: UserManager.shared.user)

    collectionViewModel.onFetchAllUserSavedShops = { savedShops in

      guard let shop = self.shop else { return }

      if savedShops.contains(shop.id) {

        self.isSavedInUserCollection = true
        self.saveButton.isSelected = true

      } else {

        self.isSavedInUserCollection = false
        self.saveButton.isSelected = false
      }
    }
  }

  func saveShopToCollection() {

    if let shop = shop {

      var savedShop = UserSavedShops()

      collectionViewModel
        .addUserSavedShopToDefaultCategory(user: UserManager.shared.user,
                                                            shop: shop,
                                                            savedShop: &savedShop)
    }
  }

  func removeSavedShopInCollection() {

    if let shop = shop {

      collectionViewModel.removeSavedShopInDefaultCategory(user: UserManager.shared.user, shop: shop)
    }
  }

  // MARK: - Private Functions
  private func setupTableView() {

    tableView.register(UINib(nibName: ShopImagesCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopImagesCell.identifier)

    tableView.register(UINib(nibName: ShopDescriptionCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopDescriptionCell.identifier)

    tableView.register(UINib(nibName: ShopFeatureCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopFeatureCell.identifier)

    tableView.register(UINib(nibName: ShopRouteCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopRouteCell.identifier)

    tableView.register(UINib(nibName: WriteReviewCell.identifier, bundle: nil),
                       forCellReuseIdentifier: WriteReviewCell.identifier)

    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 280
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.reloadData()
  }

  @objc func onTapCheckMoreReviewsBtn(sender: UIButton) {

    performSegue(withIdentifier: "navigateToReviewsVC", sender: sender)
  }

  @objc func onTapCheckRouteBtn(sender: UIButton) {

    performSegue(withIdentifier: "navigateToMapRouteVC", sender: sender)
  }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    guard let shop = shop else { return 0 }
    shopName = shop.name
    return shopsDetail.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.row {

    case 0:

      if let cell = tableView.dequeueReusableCell(withIdentifier: ShopImagesCell.identifier,
                                                  for: indexPath) as? ShopImagesCell {
        cell.selectionStyle = .none
        return cell
      }

    case 1:

      if let cell = tableView.dequeueReusableCell(withIdentifier: ShopDescriptionCell.identifier,
                                                  for: indexPath) as? ShopDescriptionCell {

        cell.checkAllReviewsBtn.tag = indexPath.row
        cell.checkAllReviewsBtn.addTarget(self,
                                          action: #selector(onTapCheckMoreReviewsBtn(sender:)),
                                          for: .touchUpInside)
        guard let shop = shop else { return ShopDescriptionCell() }

        cell.layoutShopDescriptionCell(shop: shop)
        cell.reviewsCount.text = "(\(reviewsCount))"
        cell.selectionStyle = .none

        return cell
      }

    case 2:

      if let cell = tableView.dequeueReusableCell(withIdentifier: ShopFeatureCell.identifier,
                                                  for: indexPath) as? ShopFeatureCell {

        var featureArr: [String] = []

        featureArr.append(contentsOf: recommendItemsArr.map { $0.item })

        featureArr.append(self.feature.special[0])
        featureArr.append(self.feature.special[1])
        featureArr.append(self.feature.timeLimit)
        featureArr.append(self.feature.socket)

        cell.configure(with: featureArr)

        cell.selectionStyle = .none

        return cell
      }

    case 3:

      if let cell = tableView.dequeueReusableCell(withIdentifier: ShopRouteCell.identifier,
                                                  for: indexPath) as? ShopRouteCell {

        if let shop = shop {

          cell.address.text = shop.address
          cell.markAnnotationForShop(shop: shop)
          cell.checkRouteBtn.tag = indexPath.row
          cell.checkRouteBtn.addTarget(self, action: #selector(onTapCheckRouteBtn(sender:)), for: .touchUpInside)

          cell.selectionStyle = .none

          return cell
        }
      }

    case 4:

      if let cell = tableView.dequeueReusableCell(withIdentifier: WriteReviewCell.identifier,
                                                  for: indexPath) as? WriteReviewCell {

        cell.delegate = self

        if !uploadedImgArr.isEmpty {

          switch uploadedImgArr.count {

          case 1:
            cell.uploadImgOne.isHidden = false
            cell.uploadImgOne.image    = uploadedImgArr[0]

          case 2:
            cell.uploadImgOne.isHidden = false
            cell.uploadImgTwo.isHidden = false
            cell.uploadImgOne.image    = uploadedImgArr[0]
            cell.uploadImgTwo.image    = uploadedImgArr[1]

          case 3:
            cell.uploadImgOne.isHidden    = false
            cell.uploadImgTwo.isHidden    = false
            cell.uploadImgThree.isHidden  = false
            cell.uploadImgOne.image       = uploadedImgArr[0]
            cell.uploadImgTwo.image       = uploadedImgArr[1]
            cell.uploadImgThree.image     = uploadedImgArr[2]
            cell.uploadImageBtn.isEnabled = false
            cell.uploadImageBtn.setTitleColor(.lightGray, for: .disabled)

          default:
            print("Only 3 imgs allowed")
          }
        }
        cell.selectionStyle = .none
        
        return cell
      }

    default:

      return WriteReviewCell()
    }
    return WriteReviewCell()
  }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
}

// MARK: - WriteReviewCellDelegate
extension DetailViewController: WriteReviewCellDelegate {

  func sendReview(inputReview: inout Review) {

    guard let shop = shop else { return }

    var localInputReview = inputReview

    // Publish reivew after uploading img work is done (GCD)
    let dispatchGroup = DispatchGroup()

    for index in 0..<self.uploadedImgArr.count {

      dispatchGroup.enter()

      self.addViewModel.uploadImageFromUser(with: self.uploadedImgArr[index], folderName: "userReviewsImgs")

      self.addViewModel.onUploadImage = { result in

        self.uploadedImgURLArr.append(result)

        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {

      self.addViewModel.publishUserReview(shop: shop, review: &localInputReview, uploadedImgURL: self.uploadedImgURLArr)
      
      self.showSuccessHUD(showInfo: "新增評論成功")

      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {

        self.dismiss(animated: true, completion: nil)
      }
    }
  }

  func sendRecommendItem(inputItem: inout RecommendItem) {

    guard let shop = shop else { return }

    let localInputItem = inputItem // inout parameter can't be used in closure, so copy one

    addViewModel.checkIfRecommendItemExist(shop: shop, item: localInputItem)
  }

  func onTapUploadImgBtn() {

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
            self.tableView.reloadData()

          case .video(let video):
            print("You cannot upload video lmao \(video)")
          }
        }
        picker.dismiss(animated: true, completion: nil)
      }
    }
  }
}
