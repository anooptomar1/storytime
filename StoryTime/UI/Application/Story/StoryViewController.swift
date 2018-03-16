//
// Created by Akito Nozaki on 3/13/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

class StoryViewController: StoryTimeViewController<StoryViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet var storyTable: UITableView!
    
    deinit {
        viewModel.onClose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.rowHeight = UITableViewAutomaticDimension
        storyTable.estimatedRowHeight = 140
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stories.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onSelect(viewModel.stories.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryViewCell", for: indexPath) as! StoryViewCell
        
        cell.updateLayout(with: viewModel.stories.value[indexPath.row])
        
        return cell
    }
    
}
