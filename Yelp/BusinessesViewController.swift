

import UIKit
import GoogleMaps


class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var placePicker: GMSPlacePicker?

    
    
    @IBAction func pickPlace(sender: UIButton) {
    
        let center = CLLocationCoordinate2DMake(37.788204, -122.411937)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
//                self.nameLabel.text = place.name
//                self.addressLabel.text = place.formattedAddress!.componentsSeparatedByString(", ").joinWithSeparator("\n")
            } else {
//                self.nameLabel.text = "No place selected"
//                self.addressLabel.text = ""
            }
        })
    
    
    
    }
    
    
    
    
    
    
    
    
    @IBOutlet var tableView : UITableView!
    
    var businesses: [Business] = NSArray() as! [Business]
    
    @IBAction func searchRecords(sender: AnyObject) {
        Business.searchWithTerm("pizza", sort: .Distance, categories: ["restaurants"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            if self.businesses.count != 0
            {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }}
            self.tableView.reloadData()
        }
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResultsForRestaurants(searchText);
    }
    
    func searchResultsForRestaurants(searchstring : String) {
        Business.searchWithTerm(searchstring, sort: .Distance, categories: ["restaurants"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            if self.businesses.count != 0
            {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }}
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "YelpDataCell"
        
        let cell: RestuarantSearchCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! RestuarantSearchCell
        
        let cellData: Business = self.businesses[indexPath.row]
        

        
        
        
        cell.restImage?.setImageWithURL(cellData.imageURL!)
        cell.restName?.text = cellData.name!
        cell.addressName1?.text = cellData.address!
        cell.addressName2?.text = cellData.address2!
//        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailView", sender: indexPath);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailView") {
            
            var destinationViewController = segue.destinationViewController as! RestaurantDetailViewController
            destinationViewController.businesses = self.businesses
            var currentIndex = sender as? NSIndexPath
            destinationViewController.currentIndex = (currentIndex?.row)!
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
