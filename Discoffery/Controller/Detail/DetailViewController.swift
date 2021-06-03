//
//  DetailViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class DetailViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  @IBAction func onTapBackButton(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
  }

  let activityVC = UIActivityViewController(activityItems: ["跟你分享～"], applicationActivities: nil)

  @IBAction func onTapShareButton(_ sender: Any) {
    // MARK: 現在的分享無法帶入資訊:還沒做
    present(activityVC, animated: true, completion: nil)
  }
  @IBOutlet weak var saveButton: UIButton!

  @IBAction func saveToCollection(_ sender: UIButton) {
    // MARK: 加入該用戶的收藏:還沒做
    sender.setImage(UIImage(named: "like_fill"), for: .normal)
    
    showAlert()
  }

  // MARK: - Properties
  var addViewModel = AddViewModel()

  var shop: CoffeeShop?

  var shopName = "Cafe Name"

  var reviews: [Review] = []

  var reviewsCount = 0
  
  var feature = Feature()

  var recommendItemsArr: [RecommendItem] = []

  private let shopsDetail: [CoffeeShopContentCategory] = [.images, .description, .recommend, .feature, .route, .writeReview]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()

    if let shop = shop {

      fetchReviewsForShop(shop: shop)
    }
  }

  // MARK: Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let reviewsVC = segue.destination as? ReviewsPageViewController {

      reviewsVC.reviews = self.reviews

      reviewsVC.shopName = self.shopName
    }
  }

  // MARK: TODO 這個fetchReviewsForShop是否能夠寫到HomeViewModel去?! 現在趕時間ＴＡＴ先放在這
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

  private func showAlert() {

    let alertController = UIAlertController(title: "Discoffery", message: "成功加到收藏", preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "朕知道ㄌ", style: .cancel, handler: nil)

    alertController.addAction(cancelAction)

    present(alertController, animated: true)
  }

  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.register(UINib(nibName: "ShopImagesCell", bundle: nil), forCellReuseIdentifier: "shopImagesCell")

    tableView.register(UINib(nibName: "ShopDescriptionCell", bundle: nil), forCellReuseIdentifier: "shopDescriptionCell")

    tableView.register(UINib(nibName: "ShopFeatureCell", bundle: nil), forCellReuseIdentifier: "shopFeatureCell")

    tableView.register(UINib(nibName: "ShopRouteCell", bundle: nil), forCellReuseIdentifier: "shopRouteCell")

    tableView.register(UINib(nibName: "WriteReviewCell", bundle: nil), forCellReuseIdentifier: "writeReviewCell")

    tableView.estimatedRowHeight = 280

    tableView.rowHeight = UITableView.automaticDimension

    tableView.separatorStyle = .none

    tableView.reloadData()
  }
}

extension DetailViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    guard let shop = shop else { return 0 }

    shopName = shop.name

    return shopsDetail.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    switch indexPath.row {

    case 0:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopImagesCell", for: indexPath) as? ShopImagesCell {

        cell.selectionStyle = .none

        return cell
      }

    case 1:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopDescriptionCell", for: indexPath) as? ShopDescriptionCell {

        cell.name.text = shop?.name

        cell.address.text = shop?.address

        cell.reviewsCount.text = "(\(reviewsCount))"

        cell.rateStars.rating = shop?.tasty ?? 1  // 還沒算出全部評價的平均先用api的

        cell.averageRatings.text = String(Double(cell.rateStars.rating).rounded())

        cell.openingHours.text = "因爲疫情暫時關閉"

        cell.selectionStyle = .none

        return cell
      }

    case 2:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {

        var itemsArr: [String] = []

        itemsArr.append(contentsOf: recommendItemsArr.map { $0.item })

        itemsArr.append(self.feature.special[0])

        itemsArr.append(self.feature.special[1])

        itemsArr.append(self.feature.timeLimit)

        itemsArr.append(self.feature.socket)

        cell.configure(with: itemsArr)

        cell.selectionStyle = .none

        return cell
      }

//    case 3:
//
//      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {
//
//        let featureArr = [self.feature.special[0], self.feature.special[1], self.feature.timeLimit]
//
//        cell.configure(with: featureArr)
//
//        cell.selectionStyle = .none
//
//        return cell
//      }

    case 3:
      // TODO: 地圖
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopRouteCell", for: indexPath) as? ShopRouteCell {

        cell.address.text = shop?.address

        cell.selectionStyle = .none

        return cell
      }

    case 4:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "writeReviewCell", for: indexPath) as? WriteReviewCell {

        cell.delegate = self

        cell.selectionStyle = .none

        return cell
      }

    default:

      return UITableViewCell()
    }
    return UITableViewCell()
  }
}

extension DetailViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.row {

    case 1:

      performSegue(withIdentifier: "navigateToReviewsVC", sender: indexPath.row)

    case 3:

      print("Map did select.")

    default:

      print("Row No.\(indexPath.row) did select.")
    }
  }
}

// MARK: WriteReviewCellDelegate
extension DetailViewController: WriteReviewCellDelegate {

  func sendReview(inputReview: inout Review) {

    guard let shop = shop else { return }

    addViewModel.publishUserReview(shop: shop, review: &inputReview)
  }

  func sendRecommendItem(inputItem: inout RecommendItem) {

    guard let shop = shop else { return }

    let localInputItem = inputItem // inout parameter can't be used in closure, so copy one

    addViewModel.checkIfRecommendItemExist(shop: shop, item: localInputItem)
  }

}
