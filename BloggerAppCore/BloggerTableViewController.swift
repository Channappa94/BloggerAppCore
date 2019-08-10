//
//  BloggerTableViewController.swift
//  BloggerAppCore
//
//  Created by IMCS2 on 8/8/19.
//  Copyright © 2019 com.phani. All rights reserved.
//

import UIKit
import CoreData


class BloggerTableViewController: UITableViewController {
    var array: [String] = []
    var titles: [String] = []
    var urls:[String] = []
    var savingdata: [NSManagedObject] = []
    var datas: [String] = []
    var datase: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingData()
        fetchingData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        
        return cell
    }
    
    func gettingData(){
        let url = URL(string: "https://www.googleapis.com/blogger/v3/blogs/2399953/posts?key=AIzaSyDG1DvWYWVFBTf-CzxUFU4qAR-PiEusLzk")
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil{
                if let unwrappedData = data{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        let  items = jsonResult?["items"] as? NSArray
                        DispatchQueue.main.async {
                            
                            if let count = items?.count{
                                for n in 0...count-1{
                                    let insideITem = items?[n] as! NSDictionary
                                    //appeding all the url content and putting to the variabale
                                    self.array.append(insideITem["url"] as! String)
                                    let blogTitle = items?[n] as! NSDictionary
                                    self.titles.append(blogTitle["title"] as! String)
                                    
                                }
                            }
                            self.save(itemTosave: self.titles, savingUrl: self.array)
                            self.tableView.reloadData()
                        }
                    }catch{
                        print("error")
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue", sender: self)
    }
    //takes the data passes it to the other view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue"){
            let controller = segue.destination as? ViewController
            
            let blogIndex = tableView.indexPathForSelectedRow?.row
            controller!.label = datas[blogIndex!]
            if array.count == 0{
                print("nil")
            }else{
                controller?.selectedName = array[blogIndex!]
            }
        }
        
    }
    
    
    
    func save(itemTosave: [String], savingUrl: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavingUrl",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(itemTosave, forKeyPath: "name")
        person.setValue(savingUrl, forKeyPath: "web")
        do {
            try managedContext.save()
            savingdata.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    func fetchingData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //Grabbing the xcode data model
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavingUrl")
        do {
            savingdata = try managedContext.fetch(fetchRequest)
            for saving in savingdata{
                datas = (saving.value(forKeyPath: "name") as? [String])!
            }
            
            print(savingdata)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

