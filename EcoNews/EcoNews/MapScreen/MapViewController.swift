
import UIKit
import MapKit
import Firebase
import FloatingPanel

class MapViewController: UIViewController, FloatingPanelControllerDelegate {
    
    private let locationManager = CLLocationManager()
    private var ref: DatabaseReference!
    private let userID = Auth.auth().currentUser?.uid
    private let fpc = FloatingPanelController()
    private let fpcSearch = FloatingPanelController()
    private var contentVC: ContentMarkerViewController?
    private var contentSearchVC: UIViewController?
    private var favouriteTrashcans: FavouriteTrashcans?
    private let welcomeVC = WelcomePageViewController()
    private let defaults = UserDefaults.standard
    private var allAnnotationsInGeneralMap: [MKAnnotation]!
    private let db = Firestore.firestore()
    private var coordinateUserLat: Double?
    private var coordinateUserLon: Double?
    private let distance: Double = 0.005
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnSearchAndFilter: UIButton!
    @IBOutlet weak var btnAddTrashcan: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fpc.delegate = self
        contentVC = storyboard?.instantiateViewController(identifier: "fpc_content") as? ContentMarkerViewController
        OperationsWithMap.changeAppearanceFloatingPanel(fpc: fpc)
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
        // вначале скрываем из видимости пользователя
        fpc.hide();
        self.mapView.delegate = self
        // Отображаем наши метки
        mapView.addAnnotations(MarkersLocation.allMarkers)
        favouriteTrashcans = FavouriteTrashcans()
        initBtnsBackground()
        allAnnotationsInGeneralMap = mapView.annotations
        coordinateUserLat = locationManager.location?.coordinate.latitude
        coordinateUserLon = locationManager.location?.coordinate.longitude
        
    }
    // когда нажимаем кнопку найти мусорку в поиске
    @IBAction func didUnwindFromDetailVC(_ sender: UIStoryboardSegue){
        guard let detailVC = sender.source as? DetailSearchViewController else {
            return
        }
        fpcSearch.hide()
        OperationsWithMap.zoomRegionOnMap(latitude: detailVC.trashcan.coordinate.latitude, longitude: detailVC.trashcan.coordinate.longitude, map: mapView, zoom: 100)
    }
    // кнопка фильтрации
    @IBAction func didUnwindFromFilterVC(_ sender: UIStoryboardSegue){
        guard let filterVC = sender.source as? FilterTrashcanViewController else {
            return
        }
        fpcSearch.hide()
        self.mapView.removeAnnotations(allAnnotationsInGeneralMap)
        for case let annotation as MarkersLocation? in allAnnotationsInGeneralMap {
            guard let annotation = annotation else {
                continue
            }
            if ((filterVC.isClickedPlastic && annotation.plastic) || !filterVC.isClickedPlastic)
            && ((filterVC.isClickedPaper && annotation.paper) || !filterVC.isClickedPaper)
            && ((filterVC.isClickedMetal && annotation.metall) || !filterVC.isClickedMetal)
            && ((filterVC.isClickedGlass && annotation.glass) || !filterVC.isClickedGlass)
            && ((filterVC.isClickedFavorite
            && (favouriteTrashcans!.latitudes.contains(annotation.coordinate.latitude))
            && (favouriteTrashcans!.longitudes.contains(annotation.coordinate.longitude))) || !filterVC.isClickedFavorite){
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func didUnwindFromRatingUser(_ sender: UIStoryboardSegue){
        guard let contentVC = sender.source as? ContentMarkerViewController else {
            return
        }
        guard let coordinateUserLat = coordinateUserLat else {
            return
        }
        guard let coordinateUserLon = coordinateUserLon else {
            return
        }
        if abs(contentVC.currentTrashcan.coordinate.latitude - coordinateUserLat) < distance && abs(contentVC.currentTrashcan.coordinate.longitude - coordinateUserLon) < distance{
            contentVC.btnThrowTrash.backgroundColor = UIColor(red: 255 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
            contentVC.btnThrowTrash.setTitle("Уже выбрасывали!", for: .normal)
            contentVC.btnThrowTrash.isEnabled = false
            contentVC.currentTrashcan.throwingTrash = true
            let refreshUser = db.collection("ecoUsers").document(userID!)
            refreshUser.getDocument{ (docSnapshot, error) in
                if let doc = docSnapshot {
                    if let currentRating = doc.get("rating") as? Int {
                        refreshUser.updateData(["rating": currentRating + 1])
                    } else {
                        print("error getting field")
                    }
                } else {
                    if let error = error {
                        print(error)
                    }
                }

            }
        }
    }
    
    @IBAction func didUnwindFromAddTrashcanVC(_ sender: UIStoryboardSegue){
        guard let addTrashcanVC = sender.source as? AddTrashcanViewController else {
            return
        }
        let address = addTrashcanVC.addressField
        let title = addTrashcanVC.titleField
        let latitude = addTrashcanVC.latitudeField
        let longitude = addTrashcanVC.longitudeField
        if address != nil && address?.text != ""
            && title != nil && title?.text != ""
            && latitude != nil && latitude?.text != ""
            && longitude != nil && longitude?.text != ""{
            if Double((latitude?.text)!) != nil && Double((longitude?.text)!) != nil{
                // Add a new document with a generated id.
                var ref: DocumentReference? = nil
                ref = db.collection("addedTrashcans").addDocument(data: [
                    "address": (address?.text)! as String,
                    "title": (title?.text)! as String,
                    "glass": addTrashcanVC.isClickedGlass,
                    "metal": addTrashcanVC.isClickedMetal,
                    "paper": addTrashcanVC.isClickedPaper,
                    "plastic": addTrashcanVC.isClickedPlastic,
                    "latitude": Double(latitude!.text!) ?? 0,
                    "longitude": Double(longitude!.text!) ?? 0
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            } else{
                addTrashcanVC.errorText.text = "Введите значения типа double для координат"
            }
        } else{
            addTrashcanVC.errorText.text = "Заполните поля названия, адреса и координат"
        }
    }
    
    
    func initBtnsBackground(){
        let image = UIImage(named: "search")
        self.btnSearchAndFilter.setImage(image, for: .normal)
        let imageAdd = UIImage(named: "addTrashcan")
        self.btnAddTrashcan.setImage(imageAdd, for: .normal)
    }
    
    @IBAction func clickBtnSearchAndFilter(_ sender: UIButton) {
        fpcSearch.show(animated: true, completion: nil)
        fpc.hide()
        fpcSearch.delegate = self
        let storyboard : UIStoryboard = UIStoryboard(name: "TabBarSearch", bundle: nil)
        contentSearchVC = storyboard.instantiateViewController(withIdentifier: "TabBarSearchID")
        OperationsWithMap.changeAppearanceFloatingPanel(fpc: fpcSearch)
        fpcSearch.set(contentViewController: contentSearchVC)
        fpcSearch.addPanel(toParent: self)
    }
    
    @IBAction func clickBtnAddTrashcan(_ sender: UIButton) {
        
    }
    
    
    func findTrashcanOnMap(searchingTrashcan: MarkersLocation) {
        OperationsWithMap.zoomRegionOnMap(latitude: searchingTrashcan.coordinate.latitude, longitude: searchingTrashcan.coordinate.longitude, map: mapView, zoom: 30)
        fpcSearch.hide()
    }
    // Когда уже все отобразилось
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    /// Проверяет включена ли геолокация
    func checkLocationEnabled()
    {
        if CLLocationManager.locationServicesEnabled(){
            setUpManager()
            checkAuthorization()
        }else{
            showAlertLocation(title: "У вас выключена геолокация", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
            
        }
    }
    
    func setUpManager()
    {
        locationManager.delegate = self
        // Точность определения местоположения
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization()
    {
        switch CLLocationManager.authorizationStatus(){
        // Разрешено всегда использовать местоположение
        case .authorizedAlways:
            break
        // Разрешено при использовании приложения
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        // Запрещено использование
        case .denied:
            showAlertLocation(title: "Вы запретили использование местоположения", message: "Хотите это изменить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        // Ограничено на устройстве
        case .restricted:
            break
        // Не запрошено
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    /// Показывает диалоговое сообщение пользователю
    /// - Parameters:
    ///   - title:
    ///   - message:
    ///   - url:
    func showAlertLocation(title:String, message:String?, url:URL?)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default){ (alert) in
            if let url = url{
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
 
    
    
}
extension MapViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        // чтобы приближать к какому-то месту
        if let location = locations.last?.coordinate{
            OperationsWithMap.zoomRegionOnMap(latitude: location.latitude, longitude: location.longitude, map: mapView, zoom: 50000)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}


extension MapViewController:MKMapViewDelegate {
    
    // срабатывает когда отжимаем аннотацию
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        fpc.hide()
        fpcSearch.hide()
    }
    // Меняем вьюшку для наших маркеров
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MarkersLocation else { return nil }
        var viewMarker: MKMarkerAnnotationView
        let idView = "InfoMarkerView"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView{
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            // Показ окна
            viewMarker.canShowCallout = true
            // Смещение
            viewMarker.calloutOffset = CGPoint(x: 0, y: 6)
            // Кнопка
            viewMarker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            viewMarker.glyphImage = UIImage(named: "trashcan")
//            if (annotation.glass) {
//                viewMarker.markerTintColor = UIColor(red: 0.08, green: 0.28, blue: 0.42, alpha: 1.0)
//            }
//            else if (annotation.metall) {
//                viewMarker.markerTintColor = UIColor(red: 0.09, green: 0.11, blue: 0.12, alpha: 1.0)
//            }
//            else if (annotation.paper) {
//                viewMarker.markerTintColor = UIColor(red: 0.51, green: 0.53, blue: 0.54, alpha: 1.0)
//            }
//            else {
//                viewMarker.markerTintColor = UIColor(red: 0.74, green: 0.82, blue: 0.2, alpha: 1.0)
//            }
        }
        
        // Возвращаем измененный маркер
        return viewMarker
    }
    // То что происходит при нажатии на кнопку во вьюшке маркера (строим маршрут)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        fpcSearch.hide()
        guard let coordinate = locationManager.location?.coordinate else { return }
        // Удаляем раннее построенные маршруты
        self.mapView.removeOverlays(mapView.overlays)
        let trashcan = view.annotation as! MarkersLocation
        // начальная точка пути то есть наша геопозиция
        let startPoint = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        // конечная точка пути то есть геопозиция
        let endPoint = MKPlacemark(coordinate: trashcan.coordinate)
        for case let item as MarkersLocation in MarkersLocation.allMarkers {
            if (trashcan.coordinate.latitude == item.coordinate.latitude
                    && trashcan.coordinate.longitude == item.coordinate.longitude){
                contentVC?.address.text = item.subtitle
                if (item.glass == true) {
                    contentVC?.imgGlass.image = UIImage(named: "glassTrashcan")
                } else{
                    contentVC?.imgGlass.image = UIImage(named: "wbGlass")
                }
                if (item.metall == true) {
                    contentVC?.imgMetall.image = UIImage(named: "metallTrashcan")
                } else{
                    contentVC?.imgMetall.image = UIImage(named: "wbMetall")
                }
                if (item.paper == true) {
                    contentVC?.imgPaper.image = UIImage(named: "paperTrashcan")
                } else{
                    contentVC?.imgPaper.image = UIImage(named: "wbPaper")
                }
                if (item.plastic == true) {
                    contentVC?.imgPlastic.image = UIImage(named: "plasticTrashcan")
                } else{
                    contentVC?.imgPlastic.image = UIImage(named: "wbPlastic")
                }
                break
            }
        }
        contentVC?.initDetailsContent(floatPanel: fpc, trashcan: trashcan, favTrashcans: favouriteTrashcans ?? FavouriteTrashcans())
        // проверять добавлена ли уже мусорка в избранное
        if !(favouriteTrashcans?.latitudes.contains((trashcan.coordinate.latitude)) ?? false)  &&
            !(favouriteTrashcans?.longitudes.contains(trashcan.coordinate.longitude) ?? false){
            contentVC?.btnFavourite.backgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
            contentVC?.btnFavourite.setTitle("Добавить в избранное", for: .normal)
            contentVC?.btnFavourite.isEnabled = true
        } else{
            contentVC?.btnFavourite.backgroundColor = UIColor(red: 255 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
            contentVC?.btnFavourite.setTitle("Добавлено!", for: .normal)
            contentVC?.btnFavourite.isEnabled = false
        }
        let coordinateUserLat = coordinateUserLat!
        let coordinateUserLon = coordinateUserLon!
        if abs((contentVC?.currentTrashcan.coordinate.latitude)! - coordinateUserLat) > distance + 0.0001 || abs((contentVC?.currentTrashcan.coordinate.longitude)! - coordinateUserLon) > distance + 0.0001{
            contentVC?.btnThrowTrash.backgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
            contentVC?.btnThrowTrash.setTitle("Подойдите ближе!", for: .normal)
            contentVC?.btnThrowTrash.isEnabled = false
        } else{
            if contentVC?.currentTrashcan.throwingTrash ?? false{
                contentVC?.btnThrowTrash.backgroundColor = UIColor(red: 255 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
                contentVC?.btnThrowTrash.setTitle("Уже выбрасывали!", for: .normal)
                contentVC?.btnThrowTrash.isEnabled = false
            }
            else{
                contentVC?.btnThrowTrash.backgroundColor = UIColor(red: 0 / 255.0, green: 122 / 255.0, blue: 255 / 255.0, alpha: 1)
                contentVC?.btnThrowTrash.setTitle("Выбросить мусор!", for: .normal)
                contentVC?.btnThrowTrash.isEnabled = true
            }
        }
        
        
        
        fpc.show(animated: true, completion: nil);
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        let direction = MKDirections(request: request)
        contentVC?.initRoute(map: mapView, dir: direction)
    }
    // Стиль саммх ломанных на маршруте
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 4
        return render
    }


}


