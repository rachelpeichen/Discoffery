//
//  HiddenMRTRowsViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import Eureka

class HiddenMRTRowsViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    let greenLinesStations = ["台電大樓", "公館", "西門", "新店"]

    let redLinesStations = [ "R02 象山", "R03  台北101/世貿", "R04  信義安和", "R05  大安", "R06  大安森林公園", "R07  東門", "R08  中正紀念堂", "R09  台大醫院", "R10  台北車站", "R11  中山", "R12  雙連", "R13  民權西路", "R14  圓山", "R15  劍潭", "R16  士林", "R17  芝山", "R18  明德", "R19  石牌", "R20  唭哩岸", "R21  奇岩", "R22  北投", "R22A  新北投","R23  復興崗","R24  忠義", "R25  關渡","R26  竹圍","R27  紅樹林","R28  淡水"]

    form +++ SelectableSection<CustomCheckRow<String>>("松山新店線", selectionType: .singleSelection(enableDeselection: true)) { section in

      section.header = HeaderFooterView(title: "松山新店線")
    }

    for station in greenLinesStations {
      form.last! <<< CustomCheckRow<String>(station) { lrow in
        lrow.title = station
        lrow.selectableValue = station
        lrow.value = nil
      }
    }

    form +++ SelectableSection<CustomCheckRow<String>>("淡水信義線", selectionType: .singleSelection(enableDeselection: true)) { section in

      section.header = HeaderFooterView(title: "淡水信義線")
    }

    for station in redLinesStations {
      form.last! <<< CustomCheckRow<String>(station) { lrow in
        lrow.title = station
        lrow.selectableValue = station
        lrow.value = nil
      }
    }
  }

  override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {

    if row.section === form[0] {
      print("第1個section選到:\((row.section as! SelectableSection<CustomCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
    }
    else if row.section === form[1] {
      print("第2個section選到:\((row.section as! SelectableSection<CustomCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
    }
  }
}
