//
//  ViewController.swift
//  Map
//
//  Created by Nam on 2024/06/28.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate { // 지도  델리게이트

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self // 상수 locationManager의 델리게이트를 self로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // 최고 정확도 설정
        locationManager.requestWhenInUseAuthorization() // 위치데이터 추적을 위해 사용자 승인 요청
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        myMap.showsUserLocation = true
        
        
    }

    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D{   // 경위도 표시
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)   // 경위도값을 매개변수로 CLL..함수 호출
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) // 범위 값을 매개변수로 하여 MKCoord... 호출
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)    // pLocation과 spanValue를 매개변수로 MKCoor.. 호출
        myMap.setRegion(pRegion, animated: true)    // setRegion 함수 호출
        return pLocation
    }
    
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String){  // 핀을 설치하는 함수
        let annotation = MKPointAnnotation()    //핀을 설치하기 위해 MKPoint...함수를 호출
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        
        annotation.title = strTitle
        annotation.subtitle =   strSubtitle
        myMap.addAnnotation(annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last  // 마지막 위치값을 찾아냄
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01) // 마지막 위치의 경위도 값으로 goLocation 함수 호출, delta = 0.01이므로 100배 확대해서 보여줌
        
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {    // 익명함수(클로저)
            (placemarks, error) -> Void in
            let pm = placemarks!.first  //placemarks의 첫부분만 대입
            let country = pm!.country   // pm 상수에서 나라값을 country 상수에 대입
            var address:String = country!   // 문자열 address에 country 상수의 값을 대입
            if pm!.locality != nil {    // pm 상수에서 지역값이 존재하면 address 문자열에 추가
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {    // pm 상수에서 도로값이 존재하면 address 문자열에 추가
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
            
        })
        locationManager.stopUpdatingLocation()  // 위치가 업데이트되는 것을 멈추게 함
        
    }
    
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) { // 맵 뷰 상단 세그먼트
        if sender.selectedSegmentIndex == 0 {
            //현재위치
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1{
            //가톨릭대 표시
            setAnnotation(latitudeValue: 37.486214, longitudeValue: 126.801708, delta: 1, title: "가톨릭대 성심교정", subtitle: "경기도 부천시 원미구")
        } else if sender.selectedSegmentIndex == 2{
            //선유도 표시
            setAnnotation(latitudeValue: 37.543143, longitudeValue: 126.901005, delta: 1, title: "선유도", subtitle: "서울특별시 영등포구 양화동")
        }
    }
    
    
    
}

