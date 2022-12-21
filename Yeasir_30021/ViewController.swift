

import UIKit
import PhotosUI

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var myNotes: [DataClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavItems()
        tableView.delegate = self
        tableView.dataSource = self
        readAllFilesFromDirectory()
       
    }
    
    
    // MARK: - File management
    
    // Read files from directory
    func readAllFilesFromDirectory() {
        var titleText: String?
        var desc: String?
            let filePath = getDocumentsDirectory()
        
            if let files = try? FileManager.default.contentsOfDirectory(atPath: filePath.path) {
                myNotes = []
                // loop through the files
           
                for file in files {
                     titleText = removeFileExtension(str: file)
                    
                     desc = readDescription(fileUrl: filePath, fileName: file)
                    myNotes.append(DataClass(noteTitle: titleText!, noteDescription: desc!))
                    
                }
            }
        
        tableView.reloadData()
        
        }
    
    
    // remove file extensions
    func removeFileExtension(str: String) -> String {
            // get the file extension
            let fileExtension = str.components(separatedBy: ".").last
            // remove the file extension
            let fileName = str.replacingOccurrences(of: ".\(fileExtension!)", with: "")
            return fileName
        }
    
    
    // read text files
    func readDescription(fileUrl: URL, fileName: String)-> String  {
        var desc: String = ""
        
            let filePath = fileUrl.appendingPathComponent(fileName)
            // read the data from the file
            if let data = try? Data(contentsOf: filePath) {
                // convert the data to a string
                if let text = String(data: data, encoding: .utf8) {
                    
                    desc = text
                }
            }
        return desc
    }
    
    // get document directory
    func getDocumentsDirectory()-> URL{
           // get the file path
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           let documentsDirectory = paths[0]
           let folderURL = documentsDirectory.appendingPathComponent("Note Taking App")
           print(folderURL.path)
           return folderURL
       }
    
    @objc func addNote() {
        print("Add note")
        createNote()
    }
    
    
    
   
    
    // MARK: SAVE TEXT FILE
    func saveTextFile(title: String, desc: String){
        // get document directory url
        let  fileManager = FileManager.default
        guard let documentDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return
        }
        // create folderurl
        let folderURL = documentDirURL.appendingPathComponent("Note Taking App")
        do{
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }catch{
            print(error)
        }
        
        let fileUrl = folderURL.appendingPathComponent("\(title) \(UUID().uuidString).text")
        // write the string to the file
        print(fileUrl.path)
        do {
            try desc.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - NAvigation controller
    private func configNavItems(){
         // nav buttons
        let listButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle")?.withTintColor(.gray, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(addNote))
        //nav title
        let navTitle = UILabel()
        navTitle.textColor = UIColor.darkGray
        navTitle.text = "Notes"
        navTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)!
        
        //configuration
        self.navigationItem.rightBarButtonItems = [listButton]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navTitle)
        
    }
    
    
    // MARK: - ALert controller
     func createNote() {
         let noteAlert = UIAlertController(title: "Add Note", message: "Create and keep your ntoe persistently", preferredStyle: .alert)
         
         noteAlert.addTextField { (textField) in
             textField.placeholder = "File name"
         }
         noteAlert.addTextField{ (textField) in
             textField.placeholder = "Description"
         }

         let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned noteAlert] _ in
             let title = noteAlert.textFields![0]
             let description = noteAlert.textFields![1]
             // do something interesting with "answer" here
             print(title.text!)
             print(description.text!)
            
             if let noteTitle = title.text, let noteDescription = description.text {
                 if noteTitle == "" && noteDescription == "" {
                     return
                 }else{
                     self.saveTextFile(title: noteTitle, desc: noteDescription)
                 }
                 
             }
             
             else{
                 return
             }
             self.readAllFilesFromDirectory()

         }

         
         let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
         noteAlert.addAction(submitAction)
         noteAlert.addAction(cancelAction)
         
         present(noteAlert, animated: true)
     }

}



extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath) as! TableViewCell
        let myNote = myNotes[indexPath.row]
        
        cell.noteTitle.text = myNote.noteTitle
        cell.noteDescription.text = myNote.noteDescription
        return cell
    }
}
