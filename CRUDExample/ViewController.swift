//
//  ViewController.swift
//  CRUDExample
//
//  Created by Nicky Taylor on 2/1/23.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = ViewModel()
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var storedRenameTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.bind {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.displayLabel.text = self.viewModel.kittyDescription()
            }
        }
    }
    
    @IBAction func makeKittyAction(_ sender: Any) {
        viewModel.makeKittyIntent()
    }
    
    @IBAction func fetchKittyAction(_ sender: Any) {
        viewModel.loadKittyIntent()
    }
    
    @IBAction func renameKittyAction(_ sender: Any) {
        presentRenameAlert()
    }
    
    @IBAction func deleteKittyAction(_ sender: Any) {
        viewModel.deleteKittyIntent()
    }
    
    private func presentRenameAlert() {
        
        let alert = UIAlertController(title: "Rename Kitty", message: "What would you like to name your kitty?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.delegate = self
            self.storedRenameTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            alert.dismiss(animated: true)
        }
        
        let addNameAction = UIAlertAction(title: "Okay", style: .default) { _ in
            self.viewModel.renameKittyIntent(newName: self.storedRenameTextField?.text)
            alert.dismiss(animated: true)
        }
        
        alert.addAction(addNameAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    
}
