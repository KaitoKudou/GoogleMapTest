//
//  ViewController.swift
//  TestGoogleMap
//
//  Created by 工藤海斗 on 2020/08/03.
//  Copyright © 2020 工藤海斗. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView = GMSMapView()
    let locationManager = CLLocationManager() // GoogleMapsをインポートしているためか、CoreLocationをインポートしなくてもCLLocationManagerオブジェクトを生成できる
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        showMap()
        requestLocation()
        mapView.delegate = self
    }

    func showMap(){
        // GoogleMapの初期位置(とりま東京駅)
        let camera = GMSCameraPosition.camera(withLatitude: 35.6812226, longitude: 139.7670594, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 0, height: 0), camera: camera)
        mapView.isMyLocationEnabled = true // 現在地を表示する
        self.view = mapView
    }
    
    func requestLocation(){
        // ユーザにアプリ使用中のみ位置情報取得の許可を求めるダイアログを表示
        locationManager.requestWhenInUseAuthorization()
        
        // アプリ使用中の位置情報取得の許可が得られた場合のみ、CLLocationManagerクラスのstartUpdatingLocation()を呼んで、位置情報の取得を開始する
        if .authorizedWhenInUse == CLLocationManager.authorizationStatus(){
            // 許可が得られた場合にViewControllerクラスがCLLoacationManagerのデリゲート先になるようにする
            locationManager.delegate = self
            
            // 何メートル移動ごとに情報を取得するか。ここで設定した距離分移動したときに現在地を示すマーカーも移動する
            locationManager.distanceFilter = 1
            
            // 位置情報取得開始
            locationManager.startUpdatingLocation()
        }
    }
    
    // 位置情報を取得・更新するたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        print("緯度：\(String(describing: latitude))")
        print("緯度：\(String(describing: longitude))")
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!,zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 0, height: 0), camera: camera)
        mapView.isMyLocationEnabled = true // 現在地を表示する
        
        if mapView.isHidden {
          mapView.isHidden = false
          mapView.camera = camera
        } else {
          mapView.animate(to: camera)
        }
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        <#code#>
    }
     */
    
    // マップをタップした時に呼ばれるdelegateメソッド
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
        mapView.clear() // 一旦全てのマーカーを消すことで，地図上に表示されるマーカーを1つだけにする
        
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        print("---------------------------------------------------------------")
        
        let marker = GMSMarker() // マーカーのインスタンス
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude) //タップしたときの座標をピンの座標に指定
        marker.title = name
        marker.appearAnimation = .pop // ピンを立てる時にアニメーションを追加する
        marker.map = mapView
    }
    
}

