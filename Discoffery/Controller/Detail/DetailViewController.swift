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

  let activityVC = UIActivityViewController(activityItems: ["我還不知道要怎ㄇ拿到值= ="], applicationActivities: nil)

  @IBAction func onTapShareButton(_ sender: Any) {
    // 現在的分享無法帶入資訊
    present(activityVC, animated: true, completion: nil)
  }

  @IBAction func saveToCollection(_ sender: Any) {
    // 加入該用戶的收藏
  }

  // MARK: Properties
  var shop: CoffeeShop?

  var shopName = "Cafe Name"

  var reviews: [Review] = []
  
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

  // MARK: TODO--這兩個是否能夠寫到HomeViewModel去～現在趕時間ＴＡＴ
  func fetchReviewsForShop(shop: CoffeeShop) {

    ReviewManager.shared.fetchReviewsForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getReviews):

        self?.reviews = getReviews

      case .failure(let error):

        print("fetchReviewsForShop: \(error)")
      }
    }
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

        // 先暫時用它ㄉ評分假的
        cell.rateStars.rating = shop?.cheap ?? 4
        cell.averageRatings.text = String(shop?.cheap ?? 4)

        // MARK: 營業時間還沒有弄～ＴＡＴ
        cell.openingHours.text = shop?.limitedTime

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

        let featureArr = [self.feature.atmosphere, self.feature.socket, self.feature.timeLimit]

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

      print("default")

    default:

      print("default")
    }
  }
}
