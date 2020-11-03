//
//  ViewController.swift
//  MyMap
//
//  Created by yumi kanebayashi on 2020/11/03.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // TextFieldの delegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    // Return(Search)ボタンをタップするとdelegate機能により実行されるメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        // 入力した文字を取り出す
        // OptionalBinding
        if let searchKey = textField.text {
            print(searchKey)
            
            // CLGeocoderインスタンスを取得 経度緯度⇄住所 の検索ができる
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得
            // クロージャー(無名関数)
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in

                // 位置情報が存在する場合はunwarpPlacemarksに取り出す
                if let unwarpPlacemarks = placemarks {
                    
                    // 1件目の情報を取り出す
                    if let firstPlacemark = unwarpPlacemarks.first {
                        
                        //位置情報を取り出す
                        if let location = firstPlacemark.location {
                            
                            // 位置情報から経度緯度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            
                            // 経度緯度をデバッグエリアに表示
                            print(targetCoordinate)
                            
                            // MKPointAnnotationインスタンスを取得し、ピンを生成
                            let pin = MKPointAnnotation()
                            
                            // ピンの置く場所に緯度経度を設定
                            pin.coordinate = targetCoordinate
                            
                            // ピンのタイトルを設定
                            pin.title = searchKey
                            
                            // ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            
                            // 緯度経度を中心にして半径500mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
            
        }
        
        // デフォルト動作を行うのでtrueを返す
        return true
    }
}

