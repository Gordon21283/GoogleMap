//
//  ViewController.m
//  GoogleMap
//
//  Created by Gordon Kung on 7/26/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "ViewController.h"
#import "CustomMarker.h"
@import GoogleMaps;


@interface ViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.741434
                                                            longitude:-73.990039
                                                                 zoom:16.5];
    self.mapView.myLocationEnabled = YES;
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    
    [self createTurnToTechMarker];
    [self hardCodedPins];
    
}

- (IBAction)setMap:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = kGMSTypeNormal;
            break;
        case 1:
            self.mapView.mapType = kGMSTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = kGMSTypeSatellite;
            break;
        default:
            break;
    }
}

-(void)createTurnToTechMarker {

    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.741434,  -73.990039);
    marker.title = @"TurnToTech";
    marker.snippet = @"184 5th Ave, New York, NY 10010";
    marker.map = self.mapView;
    marker.infoWindowAnchor = CGPointMake(0.5, -0.25);

}

-(void)hardCodedPins {

    GMSMarker *markerTwo = [[GMSMarker alloc] init];
    markerTwo.position = CLLocationCoordinate2DMake(40.747026, -73.9872101);
    markerTwo.title = @"Kang Ho Dong Baekjeong";
    markerTwo.snippet = @"1 E 32nd St, New York, NY 10016";
    markerTwo.map = self.mapView;
    markerTwo.infoWindowAnchor = CGPointMake(0.5, -0.25);
    
    GMSMarker *markerThree = [[GMSMarker alloc] init];
    markerThree.position = CLLocationCoordinate2DMake(40.7415171,-73.9881647);
    markerThree.title = @"Shake Shack";
    markerThree.snippet = @"Madison Square Park, Madison Ave & E.23rd St, New York, NY 10010";
    markerThree.map = self.mapView;
    markerThree.infoWindowAnchor = CGPointMake(0.5, -0.25);

}

//-(UIView*) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//
//    CustomMarker *infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"CustomMarker" owner:self options:nil]objectAtIndex:0];
//    
//    infoWindow.title.text  = marker.title;
//    infoWindow.detail.text = marker.snippet;
//    infoWindow.leftImage.image = marker.image;
//
//    
//    return infoWindow;
    
//}



//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSString *str = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.7414444,-73.99007&radius=1000&keyword=%@&key=AIzaSyCnZBMIdUn3EewxAE9p5L-npruTUHW9MtI",self.searchBar];
//    [[session dataTaskWithURL:[NSURL URLWithString:str]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error) {
//                if (error == nil) {
//                    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];

//}


@end
