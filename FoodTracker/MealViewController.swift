//
//  MealViewController.swift
//  FoodTracker
//
//  Created by David Chen on 8/17/17.
//  Copyright © 2017 The Well Tempered Company. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties

    @IBOutlet weak var mealNameField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    
    var meal: Meal?
    
    //MARK: UITextFieldDelegate
    
    //Called when user presses return
    //Removes keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Called after textField resigns first responder
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStates()
        navigationItem.title = textField.text
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    //Called after user presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Called after user picks image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
            
    }
    //MARK: Navigation
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling ", log: OSLog.default,type: .debug)
            return
        }
        let name = mealNameField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
        
            
    }
   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: Actions
    
    //Called when user taps the placeholder photo
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        //If user taps photo when keyboard is up, close keyboard
        mealNameField.resignFirstResponder()
        
        //Create a new view controller of class UIImagePickerController
        let imagePickerController = UIImagePickerController()
        
        //Choose the source of imagePickerController as camera roll
        imagePickerController.sourceType = .photoLibrary
        
        //Choose delegate as UIViewController
        imagePickerController.delegate = self
        
        //Present imagePickerController with animation, do not run any code after completion
        present(imagePickerController, animated: true,completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealNameField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            mealNameField.text = meal.name
            photoImageView.image = meal.image
            ratingControl.rating = meal.rating
        }
        
        updateSaveButtonStates()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Private methods
    
    private func updateSaveButtonStates() {
        let text = mealNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

