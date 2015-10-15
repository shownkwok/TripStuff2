//
//  TripDetailSettingViewController.swift
//  TripStuff2
//
//  Created by SHAWN on 9/17/15.
//  Copyright © 2015 SHAWN. All rights reserved.
//

import UIKit

class TripDetailSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var tripInfoToBeEdit: TripInfo?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("s")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("s")
        if let trip = tripInfoToBeEdit{
            timeFrom.date = trip.timeBegin!
            timeTo.date = trip.timeEnd!
  //          noteForTrip.text = trip.note
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var stayOrMoveStatus: UIPickerView!
    @IBOutlet weak var timeFrom: UIDatePicker!{
        didSet{
            timeFrom.datePickerMode = UIDatePickerMode.Time
            timeFrom.minuteInterval = 30
        }
    }
    
    @IBOutlet weak var timeTo: UIDatePicker!{
        didSet{
            timeTo.datePickerMode = UIDatePickerMode.Time
            timeTo.minuteInterval = 30
        }
    }
    
    @IBOutlet weak var routFromMap: UIImageView!
    
    @IBOutlet weak var spend: UITextField!
    
    @IBAction func searchPlacesFromMap(sender: UIButton) {
    }
    
    
    @IBAction func done(sender: UIBarButtonItem) {
//        if placeFrom.text == ""{
//            print("placeFrom is nil")
//        }else if (timeTo.date == timeTo.date.earlierDate(timeFrom.date)){
//            print("time is wrong")
//        }else{
//            tripInfoToBeEdit = TripInfo(placeFrom: placeFrom.text!, timeBegin: timeFrom.date, timeEnd: timeTo.date)
//            tripInfoToBeEdit?.status = Constant.StayOrMoveStatusDetail[stayOrMoveStatus.selectedRowInComponent(0)][stayOrMoveStatus.selectedRowInComponent(1)]
//            if placeTo.text != ""{
//                tripInfoToBeEdit?.placeTo = placeTo.text!
//            }
//            if routFromMap != nil{
//                tripInfoToBeEdit?.imageForRouteInMap = routFromMap.image
//            }
//            if spend.text != ""{
//                tripInfoToBeEdit?.price = Double(spend.text!)!
//            }
//            
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
//MARK: Set pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return Constant.StayOrMoveStatusColume.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0{
            return Constant.StayOrMoveStatusColume.count
        }
        else
        {
            if pickerView.selectedRowInComponent(0) == 0{
                return Constant.StayOrMoveStatusDetail[0].count
            }else{
                return Constant.StayOrMoveStatusDetail[1].count
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return Constant.StayOrMoveStatusColume[row]
        }
        else
        {
            if pickerView.selectedRowInComponent(0) == 0{
                return Constant.StayOrMoveStatusDetail[0][row]
            }else{
                return Constant.StayOrMoveStatusDetail[1][row]
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            stayOrMoveStatus.reloadAllComponents()
        }
    }
    
    
    //MARK: set textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        noteForTrip.resignFirstResponder()
        spend.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
