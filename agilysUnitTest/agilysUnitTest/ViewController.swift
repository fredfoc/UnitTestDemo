//
//  ViewController.swift
//  agilysUnitTest
//
//  Created by fauquette fred on 28/01/16.
//  Copyright © 2016 Agilys. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    
    @IBOutlet private weak var tableView: UITableView!
    
    private var result: [BingCustomSearchItemModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            result = try DataProviderManager.sharedInstance.getResult()
        } catch DataError.NoData {
            print("You must provide a valid file.")
        } catch DataError.Empty {
            print("The file is empty.")
        } catch DataError.Serialize {
            print("We could not serialize the object.")
        } catch {
            print("Something went wrong!")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = result else {
            return 0
        }
        return result.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        if let model = result?[indexPath.row] {
            cell.updateCell(model)
        }
        return cell
    }
}


class CustomCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var thumbNail: UIImageView!
    
    func updateCell(model: BingCustomSearchItemModel) {
        titleLabel.text = model.imageId
        if let urlStr = model.imageURL {
            thumbNail.sd_setImageWithURL(NSURL(string: urlStr))
        }
        
    }
}



