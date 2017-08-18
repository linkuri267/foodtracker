//
//  RatingControl.swift
//  FoodTracker
//
//  Created by David Chen on 8/17/17.
//  Copyright © 2017 The Well Tempered Company. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSeletionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setupButtons()
        }
    }

    //MARK: Initialization 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if (selectedRating == rating)
        {
            rating = 0
        }
        
        else
        {
            rating = selectedRating
        }
        
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        //Remove existing buttons on screen then clear list
        for x in 0..<ratingButtons.count{
            removeArrangedSubview(ratingButtons[x])
            ratingButtons[x].removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        //Create new buttons based on parameters starCount and starSize
        for _ in 0..<starCount {
        
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            //Add constraints 
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Setup button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //Add button to the stack
            addArrangedSubview(button)
            
            ratingButtons.append(button)
            
            //Update selection states 
            updateButtonSeletionStates()
        }
    }
    
    private func updateButtonSeletionStates(){
        for x in 0..<ratingButtons.count
        {
            if x < rating
            {
                ratingButtons[x].isSelected = true
            }
            else
            {
                ratingButtons[x].isSelected = false
            }
            
        }
    }

}
