//
//  ViewController.swift
//  JRService
//
//  Created by xj on 12/07/2021.
//  Copyright (c) 2021 xj. All rights reserved.
//

import UIKit
import JRService
import RxSwift

class ViewController: UIViewController {

    let viewModel: DemoViewModelType = DemoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        binding()
        
        trackRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    
    func binding () {
        viewModel.outputs.trackRecordResult.subscribe { result in
            
        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    
    
    func trackRecord(){
        
        viewModel.inputs.trackRecord()
    }
}
