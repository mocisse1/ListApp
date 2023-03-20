//
//  ViewController.swift
//  ListApp
//
//  Created by Mamoudou Cisse on 3/8/23.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private var models = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "GroceryList"
        getAllItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "NewList", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler:{ _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self.createItems(name: text)
            
            
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            
            let alert = UIAlertController(title: "Edit List", message: "Edit your List", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler:{ _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self.updateItem(item: item, newname: newName)
                
                
            }))
            self.present(alert, animated: true)
            
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler:{ _ in
            self.deleteItem(item: item)
        }))
            
        present(sheet, animated: true)
    

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    func getAllItems(){
        do {
            models = try context.fetch(List.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
        }
    }
    func createItems(name: String) {
        let newItem = List(context: context)
        newItem.name = name
        newItem.date = Date()
        getAllItems()
        print(name)
        do {
            try context.save()
        }
        catch {
            
        }
    }
    func deleteItem(item: List) {
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    func updateItem(item: List, newname: String) {
        item.name = newname
        getAllItems()
        do{
            try context.save()
        }
        catch{
            
        }
    }
}


