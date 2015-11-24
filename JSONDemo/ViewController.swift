//
//  ViewController.swift
//  JSONDemo
//
//  Created by TheAppGu/Users/usuario/Desktop/json-parsing-example-swift-master/JSONDemo/ViewController.swiftruz-New-6 on 31/07/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    let yourJsonFormat: String = "JSONUrl" // set text JSONFile : json data from file
                                            // set text JSONUrl : json data from web url
    
    var arrDict :NSMutableArray=[]
    
    @IBOutlet weak var textFieldBuscar: UITextField!
    @IBOutlet weak var tvJSON: UITableView!
    
    @IBAction func click(sender: UIButton) {
        if yourJsonFormat == "JSONFile" {
            jsonParsingFromFile()
        } else {
            jsonParsingFromURL()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if yourJsonFormat == "JSONFile" {
            jsonParsingFromFile()
        } else {
            jsonParsingFromURL()
        }
    }
    
    func jsonParsingFromURL () {
        let url = NSURL(string: ("https://itunes.apple.com/search?term=" + textFieldBuscar.text! as String).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "&limit=20")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            self.startParsing(data!)
        }
    }
    
    func jsonParsingFromFile()
    {
        let path: NSString = NSBundle.mainBundle().pathForResource("itunes", ofType: "json")!
        let data : NSData = try! NSData(contentsOfFile: path as String, options: NSDataReadingOptions.DataReadingMapped)
        
        self.startParsing(data)
    }
    
    func startParsing(data :NSData)
    {
        let dict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        arrDict.removeAllObjects()
        for var i = 0 ; i < (dict.valueForKey("results") as! NSArray).count ; i++
        {
            arrDict.addObject((dict.valueForKey("results") as! NSArray) .objectAtIndex(i))
        }
        
    
        tvJSON.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : TableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        if(cell == nil)
        {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! TableViewCell;
        }
        let strTitle : NSString=arrDict[indexPath.row] .valueForKey("trackName") as! NSString
        let strDescription : NSString=arrDict[indexPath.row] .valueForKey("artistName") as! NSString
        let strAlbumUrl : NSString=arrDict[indexPath.row] .valueForKey("artworkUrl60") as! NSString
        let strAlbum : NSString=arrDict[indexPath.row] .valueForKey("collectionName") as! NSString
        let strGenero : NSString=arrDict[indexPath.row] .valueForKey("primaryGenreName") as! NSString
        let strPrecio : Double=arrDict[indexPath.row] .valueForKey("trackPrice") as! Double
        let strMoneda : NSString=arrDict[indexPath.row] .valueForKey("currency") as! NSString
        
        cell.lblTitle.text=strTitle as String
        cell.lbDetails.text=strDescription as String
        cell.lbAlbum.text=strAlbum as String
        cell.lbGenero.text=strGenero as String
        cell.lbPrecio.text=(String(strPrecio)) + " " + (strMoneda as String)
        cell.ivAlbumImage.imageFromUrl(strAlbumUrl as String)
        
        return cell as TableViewCell
    }
    
    
}