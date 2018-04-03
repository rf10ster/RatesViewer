//
//  RatesViewController.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 28/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxMoya
import RxDataSources

class RatesViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: RateListVM!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<RatesService>()
        let flagService = CircleFlagService()
        // TODO: store baseCurrency somewhere in the settings
        viewModel = RateListVM(baseCurrency: "EUR", provider: provider, flagService: flagService)
        
        setupRx()
        
        viewModel.fetch()
        
        let _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [viewModel] _ in
                viewModel?.fetch()
            })
        .disposed(by: self.disposeBag)
    }
    
    private func setupRx() {
        

        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { ds, tv, ip, rateItem in
                let cell: RateItemCell = tv.dequeueReusableCell(withIdentifier: String(describing: RateItemCell.self)) as! RateItemCell
                
                cell.flagImageView.image = rateItem.flagImage
                cell.currencyCodeLabel.text = rateItem.currencyCode
                cell.currencyDescriptionLabel.text = rateItem.currencyDescription
                
                let _ = cell.rateValueTextField.rx.text.asObservable().filter { _ in cell.isSelected }.subscribe(onNext: { txt in
                    if let currencyAmount = Double(txt ?? "0") {
                        self.viewModel.baseCurrencyAmount.value = currencyAmount / rateItem.rateValue.value
                    }
                })
                    .disposed(by: self.disposeBag)
                
                let currencyAmount: Observable<String> =
                    Observable.combineLatest(rateItem.rateValue.asObservable(), self.viewModel.baseCurrencyAmount.asObservable())
                    { rate,baseAmount in return String(format: "%.02f", rate * baseAmount)}
                        .filter { _ in return !cell.isSelected }
                
                currencyAmount.bind(to: cell.rateValueTextField.rx.text)
                    .disposed(by: self.disposeBag)
                
                return cell

        },
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )

        viewModel.sections.asObservable()
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(RateItemVM.self)
            .subscribe(onNext: { [tableView, viewModel] item in
                viewModel?.moveItemToTop(from: item.position)
                let topIndexPath = IndexPath(row: 0, section: 0)
                tableView?.scrollToRow(at: topIndexPath, at: .top, animated: true)
            })
            .disposed(by: disposeBag)
    }

}

