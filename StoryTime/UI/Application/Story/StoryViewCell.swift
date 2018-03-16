//
// Created by Akito Nozaki on 3/13/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import UIKit

class StoryViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var storyImage: UIImageView!
    
    func updateLayout(with story: Story) {
        title.text = story.title
        storyImage.image = story.image
    }
}
