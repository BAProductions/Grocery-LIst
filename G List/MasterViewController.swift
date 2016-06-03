//
//  MasterViewController.swift

// <Grocery-LIst is a simple list appclation for ios 9.3 an above and swift 2.2 an above>
// Copyright (C) <2016>  <DJABHipHop/BAProductions>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
    
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


import UIKit
import MessageUI
import AVFoundation
import AudioToolbox
class MasterViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate,MFMailComposeViewControllerDelegate{
    //Cell Font Size for both label PS for simulater use 16 for phone use 20
    var fontSize:CGFloat = 20;
    //Cell Font Size for both label PS for simulater use 16 for phone use 20
    var fontSizeAlert:CGFloat = 15;
    //Cell Font Name for both label PS some font may requir bigger number
    var fontName:String = "Avenir";
    //Row Height PS for simulater use 38 for phone use 48
    var row:CGFloat = 48;
    //iTUNES CONNECT APP ID
    var appID:String = "103929392";
    //Minimum Sessions
    var iMinSessions = 3
    //Minimum Try Again Sessions
    var iTryAgainSessions = 6
    //App name
    var appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    //UIToolBar Spacer
    var spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action:nil)
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        Note.loadnotes()
        noteTable = self.tableView
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Add edit button to nav bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.tableView.backgroundColor = hexStringToUIColor("#fffefc")
        //Add insert data button to nav bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.title = "\(appName.localizedWithComment("Name"))"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.separatorColor = UIColor.grayColor()
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        self.tableView?.tableHeaderView = nil
        self.tableView?.tableFooterView = nil
        //self.tableView.hideSearchBar()
        self.tableView.allowsMultipleSelection = true;
        self.tableView.rowHeight = row;
        //self.tableView.allowsMultipleSelectionDuringEditing = true;
        self.disablesAutomaticKeyboardDismissal()
        let resetbutton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(resetChecks(_:)))
        //let email = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(sendEmailButtonTapped(_:)))
        self.setToolbarItems([spacer,resetbutton,spacer], animated: false)
        self.navigationController!.setToolbarHidden(false, animated: false)
        //Rate appclation code
        self.rateMe()
        iMinSessions = 0
        iTryAgainSessions = 6
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "neverRate")
        NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "numLaunches")
        let os = NSProcessInfo()
        print(os.processName.localizedWithComment("PN"));
    }
    //rate appclation code
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            self.showRateMe()
            numLaunches = iMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    //Show rate appclation code
    func showRateMe() {
        //AppNAme
        //Show rate appclation code
        let alert = UIAlertController(title: "Rate Us".localizedWithComment("RU"), message: "Thanks for using ".localizedWithComment("TFU")+appName.localizedWithComment("Name"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.layer.cornerRadius = 20
        alert.view.layer.masksToBounds = true
        alert.view.layer.borderWidth = 1.5
        alert.view.layer.borderColor = UIColor.grayColor().CGColor
        alert.addAction(UIAlertAction(title: "Rate ".localizedWithComment("Rate")+appName.localizedWithComment("Name"), style: UIAlertActionStyle.Default, handler: { alertAction in
            //UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/\(self.appID)")!)
            print("itms-apps://itunes.apple.com/app/\(self.appID)")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks".localizedWithComment("NT"), style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later".localizedWithComment("ML"), style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    /*func sendEmailButtonTapped(sender: AnyObject) {
     let mailComposeViewController = configuredMailComposeViewController()
     if MFMailComposeViewController.canSendMail() {
     self.presentViewController(mailComposeViewController, animated: true, completion: nil)
     } else {
     self.showSendMailErrorAlert()
     }
     }
     
     func configuredMailComposeViewController() -> MFMailComposeViewController {
     let mailComposerVC = MFMailComposeViewController()
     mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
     
     mailComposerVC.setToRecipients(["someone@somewhere.com"])
     mailComposerVC.setSubject("Sending you an in-app e-mail...")
     mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
     mailComposerVC.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
     
     return mailComposerVC
     }
     
     func showSendMailErrorAlert() {
     //let alert = UIAlertController(title: "Add Item To Grocery List", message: "", preferredStyle: .Alert)
     //alert.show()
     }
     
     // MARK: MFMailComposeViewControllerDelegate Method
     func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
     controller.dismissViewControllerAnimated(true, completion: nil)
     }*/
    //Reset list/Clear all checkmarks
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
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath){
        cell.separatorInset = UIEdgeInsetsMake(10, 20, 10, 20)
        cell.layoutMargins = UIEdgeInsetsMake(10, 20, 10, 20)
        cell.preservesSuperviewLayoutMargins = false
        //TipInCellAnimator.fadeIn(cell)
    }
    
    //need if list has more then one section
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
    
    //need if uisearchbar is present in list
    /*
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
     searchBar.endEditing(true)
     searchBar.resignFirstResponder()
     }
     func searchBarSearchButtonClicked(searchBar: UISearchBar) {
     searchBar.resignFirstResponder()
     }*/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*var customkeyboardView : UIView {
     
     let nib = UINib(nibName: "keyboard", bundle: nil)
     let objects = nib.instantiateWithOwner(self, options: nil)
     let cView = objects[0] as! UIView
     return cView
     }*/
    //Add items to list
    func insertNewObject(sender: AnyObject) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        allNotes.insert(Note(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.editing = false
        let alert = UIAlertController(title: "Add Item To".localizedWithComment("AIT")+firstCharacterLowerCase(appName.localizedWithComment("name")),
                                      message: "",
                                      preferredStyle: .Alert)
        let placeHolderColor:UIColor = .darkGrayColor()
        alert.view.layer.cornerRadius = 20
        alert.view.layer.masksToBounds = true
        alert.view.layer.borderWidth = 1.5
        alert.view.layer.borderColor = UIColor.grayColor().CGColor
        let ItemConfigClosure: ((UITextField!) -> Void)! = { text in
            text.placeholder = "Type Item Name Here".localizedWithComment("TINH")
            text.attributedPlaceholder = NSAttributedString(string:"Type Item Name Here".localizedWithComment("TINHD"),attributes:[NSForegroundColorAttributeName:placeHolderColor])
            text.adjustsFontSizeToFitWidth = true
            text.autocapitalizationType = .Words
            text.autocorrectionType = .Yes
            text.font = UIFont(name: self.fontName, size:self.fontSizeAlert)
        }
        alert.addTextFieldWithConfigurationHandler(ItemConfigClosure)
        let lb = UIBarButtonItem(title: "LB", style: .Plain, target: nil, action: nil)
        let h = UIBarButtonItem(title: "H", style: .Plain, target: nil, action: nil)
        let m = UIBarButtonItem(title: "M", style: .Plain, target: nil, action: nil)
        let s = UIBarButtonItem(title: "S", style: .Plain, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width,(navigationController?.navigationBar.frame.size.height)!))
        toolbar.setItems([self.spacer,lb,self.spacer,h,self.spacer,m,self.spacer,s,self.spacer], animated: false)
        let amountConfigClosure: ((UITextField!) -> Void)! = { text in
            text.placeholder = "Type Quantity Here".localizedWithComment("TQH")
            text.attributedPlaceholder = NSAttributedString(string:"Type Quantity Here".localizedWithComment("TQHD"),attributes:[NSForegroundColorAttributeName: placeHolderColor])
            text.adjustsFontSizeToFitWidth = true
            text.autocapitalizationType = .None
            text.autocorrectionType = .No
            text.font = UIFont(name: self.fontName, size: self.fontSizeAlert)
            text.keyboardType = UIKeyboardType.NumbersAndPunctuation
            //text.inputView = self.customkeyboardView
            //text.inputView = self.customkeyboardView
            //text.inputAccessoryView = toolbar
            print(text.inputView?.frame)
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
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                Note.saveNotes()
            }
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
    //count of sections in list
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //count of items in list
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    //Render items in list view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //Clear's Cell Color to UITableView color can be used insted
        cell.backgroundColor = UIColor.clearColor()
        //override margin in UITableView again
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsMake(10, 15, 10, 20)
        cell.layoutMargins = UIEdgeInsetsMake(10, 15, 10, 20)
        //override font and font size for textLabel
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.font = UIFont(name:fontName, size:fontSize)
        //override font and font size for detailTextLabel
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel!.font = UIFont(name:fontName, size:fontSize)
        //object var
        let object = allNotes[indexPath.row]
        //override font and font size for detailTextLabel
        cell.textLabel!.text = firstCharacterUpperCase(object.note.localizedWithComment("Note"))
        //override font and font size for detailTextLabel
        cell.detailTextLabel!.text = firstCharacterUpperCase(object.amount.localizedWithComment("Amount"))
        //override font and font size for detailTextLabel
        cell.detailTextLabel!.textColor = UIColor.darkGrayColor()
        //disable seltions for UITableView
        cell.selectionStyle = .None;
        //override tint coloe for UITableView checkmark
        cell.tintColor = hexStringToUIColor("#7F7F7F")
        if object.checked == "1" {
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        return cell
    }
    //Mark items in list as done old code till work but i think swiping is faster you deside both will work
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
    //Mark or Remove items in list with swipe actions
    override func tableView(tableView: UITableView,
                            editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
        //delete item code
        let delete = UITableViewRowAction(style: .Normal, title: "Delete".localizedWithComment("Dlete")) { action, index in
            
            allNotes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            Note.saveNotes();
        }
        delete.backgroundColor = UIColor.redColor()
        //mark item as done code
        let markAsDone = UITableViewRowAction(style: .Normal, title: "Mark As Done".localizedWithComment("MAD")) { action, index in
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
        //this code is optional depend on what you doing
        if allNotes[indexPath.row].checked == "1" {
            return [delete]
        }else{
            return [delete,markAsDone]
        }
    }
    //Reorder items in list
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = allNotes[fromIndexPath.row]
        allNotes.removeAtIndex(fromIndexPath.row)
        allNotes.insert(itemToMove, atIndex: toIndexPath.row)
        Note.saveNotes()
    }
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    //Remove items from list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if (editingStyle == .Delete) {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                TipInCellAnimator.fadeOut(cell)
                allNotes.removeAtIndex(indexPath.row)
                Note.saveNotes();
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }
}

