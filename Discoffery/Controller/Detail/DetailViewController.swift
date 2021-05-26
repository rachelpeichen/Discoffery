//
//  DetailViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class DetailViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!

  @IBAction func onTapBackButton(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
  }

  let activityVC = UIActivityViewController(activityItems: ["ㄩㄇ？"], applicationActivities: nil)

  @IBAction func onTapShareButton(_ sender: Any) {
    // 現在的分享無法帶入資訊
    present(activityVC, animated: true, completion: nil)
  }
  @IBOutlet weak var saveButton: UIButton!

  @IBAction func saveToCollection(_ sender: UIButton) {
    // 加入該用戶的收藏
    sender.setImage(UIImage(named: "like_fill"), for: .normal)
    
    showAlert()
  }

  // MARK: Properties
  var addViewModel = AddViewModel()

  var shop: CoffeeShop?

  var shopName = "Cafe Name"

  var reviews: [Review] = []

  var reviewsCount = 0
  
  var feature = Feature()

  private let shopsDetail: [CoffeeShopContentCategory] = [.images, .description, .recommend, .feature, .route, .writeReview]

  // MARK: Life Cycle
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

      guard reviews != nil else { return }

      reviewsVC.reviews = self.reviews

      reviewsVC.shopName = self.shopName
    }
  }

  // MARK: TODO--這個fetchReviewsForShop是否能夠寫到HomeViewModel去～現在趕時間ＴＡＴ
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

    guard shop != nil else { return 0 }

    shopName = shop!.name

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

        // MARK: 還沒算出全部評價的平均先給隨機ㄉ
        cell.rateStars.rating = Double.random(in: 1...5)

        cell.averageRatings.text = String(cell.rateStars.rating)

        // MARK: 營業時間還沒有弄～ＴＡＴ
        cell.openingHours.text = "因爲疫情暫時關閉"

        cell.selectionStyle = .none

        return cell
      }

    case 2:
      // 推薦商品：還沒有弄，先寫假的三個
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {

        let mockArr = ["摩卡可可碎片星冰樂", "馥列白", "醇濃抹茶那堤"]

        cell.configure(with: mockArr)

        cell.selectionStyle = .none

        return cell
      }

    case 3:
      // 環境特色：先寫死三個Firebase上面的假資料
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {

        cell.feature = self.feature

        let featureArr = [self.feature.special[0], self.feature.special[1], self.feature.timeLimit]

        cell.configure(with: featureArr)

        cell.selectionStyle = .none
        
        return cell
      }

    case 4:
      // 地圖
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopRouteCell", for: indexPath) as? ShopRouteCell {

        cell.address.text = shop?.address

        cell.selectionStyle = .none

        return cell
      }

    case 5:
      // 寫評論
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

    case 4: // 大地圖

      print("點到地圖")

    case 5:

      print("點到寫評論的cell")

    default:

      print("點到第 \(indexPath.row)個 Row")
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

    // 檢查這個推薦品是否已經在火地上？ 有的話在已有推薦品doc下count加一 沒有的話創一個新doc

    let group = DispatchGroup()

    let serial = DispatchQueue(label: "myQ")

    var localInputItem = inputItem

    var itemDidExist = false

    group.enter()

    serial.async {

      itemDidExist = self.addViewModel.checkIfRecommendItemExist(shop: shop, item: localInputItem)
    }

    group.notify(queue: .main) {

      if !itemDidExist {

        self.addViewModel.updateRecommendItemCount(shop: shop, item: localInputItem)

      } else {

        self.addViewModel.publishRecommendItem(shop: shop, item: &localInputItem)
      }
    }
    
  }

}
