//
//  MasterViewController.swift
//  G List
//
//  Created by BAProductions on 5/12/16.
//  Copyright © 2016 BAProductions. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate{

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        Note.loadnotes()
        noteTable = self.tableView
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let logo = UIImageView(frame: CGRectMake(0, 0, 200, 40))
        logo.image = UIImage(named:"shopping-cart")
        //self.navigationItem.titleView = logo
        self.tableView.backgroundColor = hexStringToUIColor("#fffefc")
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named:"seamless_paper_texture")
        //self.tableView.backgroundView = imageViewBackground
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.title = "Grocery List"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorColor = UIColor.grayColor()
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        //searchBar.enablesReturnKeyAutomatically = true
        self.tableView.hideSearchBar()
        let resetbutton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(resetChecks(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: #selector(resetChecks(_:)))
        self.setToolbarItems([spacer,resetbutton,spacer], animated: true)
        self.navigationController!.setToolbarHidden(false, animated: false)
        let appname = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        if NSUserDefaults.standardUserDefaults().boolForKey("neverRate"){
        }else{
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for using "+appname, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Rate "+appname, style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/<ITUNES CONNECT APP ID>")!)
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func resetChecks(sender: AnyObject) {
        for i in 0...tableView.numberOfSections-1 {
            for j in 0...tableView.numberOfRowsInSection(i) - 1 {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) {
                    cell.accessoryType = .None
                    allNotes[j].checked = "0"
                    Note.saveNotes();
                }
            }
        }
    }
    override func tableView(_tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
            cell.separatorInset = UIEdgeInsetsMake(10, 20, 10, 20)
            cell.layoutMargins = UIEdgeInsetsMake(10, 20, 10, 20)
            cell.preservesSuperviewLayoutMargins = false
    }
    /*override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIToolbar(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
        footerView.barTintColor = hexStringToUIColor("#CFCFCF")
        return footerView
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let uilbl = UILabel()
        //uilbl.numberOfLines = 0
        //uilbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //uilbl.text = "blablabla"
        uilbl.sizeToFit()
        uilbl.backgroundColor =  hexStringToUIColor("#CFCFCF")
        uilbl.text = allNotes[currentNoteIndex].amount
        
        return uilbl
    }*/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        allNotes.insert(Note(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let alert = UIAlertController(title: "Add Item To Grocery List",
                                      message: "",
                                      preferredStyle: .Alert)
        let ItemConfigClosure: ((UITextField!) -> Void)! = { text in
            text.placeholder = "Type Item Name Here"
        }
        alert.addTextFieldWithConfigurationHandler(ItemConfigClosure)
        let amountConfigClosure: ((UITextField!) -> Void)! = { text in
            text.placeholder = "Type Quantity Here"
        }
        alert.addTextFieldWithConfigurationHandler(amountConfigClosure)
        let add = UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let tf = (alert.textFields?[0])! as UITextField
            let TFF = noEmoji(tf.text!)
            let tf2 = (alert.textFields?[1])! as UITextField?
            let TFF2 = noEmojiOrLatter(tf2!.text!)
            if TFF == "" {
                allNotes.removeAtIndex(currentNoteIndex)
            } else {
                allNotes[currentNoteIndex].note = TFF
                if TFF2 == "" || TFF2 == "1" {
                    allNotes[currentNoteIndex].amount = "1"
                }else{
                    allNotes[currentNoteIndex].amount = TFF2
                }
            }
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            Note.saveNotes()
            noteTable?.reloadData()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            allNotes.removeAtIndex(currentNoteIndex)
            Note.saveNotes()
            noteTable?.reloadData()
        }
        alert.addAction(add)
        alert.addAction(cancel)
        self.presentViewController(alert, animated:true, completion:nil)
    }
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsMake(10, 15, 10, 20)
        cell.layoutMargins = UIEdgeInsetsMake(10, 15, 10, 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.font = UIFont(name:"Avenir", size:16)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel!.font = UIFont(name:"Avenir", size:16)
        let object = allNotes[indexPath.row]
        cell.textLabel!.text = firstCharacterUpperCase(object.note)
        cell.detailTextLabel!.text = firstCharacterUpperCase(object.amount)
        cell.detailTextLabel!.textColor = UIColor.darkGrayColor()
        cell.selectionStyle = .None;
        cell.tintColor = hexStringToUIColor("#7F7F7F")
        if object.checked == "1" {
            cell.accessoryType = .Checkmark
            print(object.checked)
        }else{
            cell.accessoryType = .None
            print(object.checked)
        }
        return cell
    }
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                    allNotes[indexPath.row].checked = "0"
                    Note.saveNotes();
                } else {
                    cell.accessoryType = .Checkmark
                    allNotes[indexPath.row].checked = "1"
                    Note.saveNotes();
                }
            }    
    }*/
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(tableView: UITableView,
                              editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            allNotes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            Note.saveNotes();
        }
        delete.backgroundColor = UIColor.redColor()
        
        let markAsDone = UITableViewRowAction(style: .Normal, title: "Mark As Done") { action, index in
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                    tableView.editing = false
                    allNotes[indexPath.row].checked = "0"
                    Note.saveNotes();
                } else {
                    tableView.editing = false
                    cell.accessoryType = .Checkmark
                    allNotes[indexPath.row].checked = "1"
                    Note.saveNotes();
                }
            }
        }
        markAsDone.backgroundColor = hexStringToUIColor("#0679fa")
        if allNotes[indexPath.row].checked == "1" {
            return [delete]
        }else{
            return [delete,markAsDone]
        }
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            allNotes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            Note.saveNotes();
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

