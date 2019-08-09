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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingData()
        gettingData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
    }
    
    func gettingData(){
        let url = URL(string: "https://www.googleapis.com/blogger/v3/blogs/2399953/posts?key=AIzaSyDG1DvWYWVFBTf-CzxUFU4qAR-PiEusLzk")
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil{
                if let unwrappedData = data{
                    do{
                        //prints all the content of the arry inside the wesite
                        let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        let  items = jsonResult?["items"] as? NSArray
                        DispatchQueue.main.async {
                            
                            if let count = items?.count{
                                for n in 0...count-1{
                                    let insideITem = items?[n] as! NSDictionary
                                    //appeding all the url content and putting to the variabale
                                    self.array.append(insideITem["url"] as! String)
                                    print(self.array)
                                    let blogTitle = items?[n] as! NSDictionary
                                    self.titles.append(blogTitle["title"] as! String)
                                    
                                }
                            }
                            self.save(itemTosave: self.titles)
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
            controller?.selectedName = array[blogIndex!]
            controller!.label = titles[blogIndex!]
            //print(titles)
        }
    }
    
    
    
    func save(itemTosave: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavingUrl",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(itemTosave, forKeyPath: "name")
        savingdata.append(person)
        do {
            try managedContext.save()
            print(savingdata)
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
            let person: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            print(person[0].value(forKeyPath: "name") as? String)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
}
