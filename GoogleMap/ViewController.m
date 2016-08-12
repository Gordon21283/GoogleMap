//
//  ViewController.m
//  GoogleMap
//
//  Created by Gordon Kung on 7/26/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "ViewController.h"
#import "CustomMarker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@import GoogleMaps;


@interface ViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//global location variables
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self createTurnToTechMarker];
    [self hardCodedPins];
  
    //LocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
  
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                          longitude:self.currentLocation.coordinate.longitude
                                                               zoom:16.5];
    self.mapView.camera = camera;
  
    //audio player & path to mp3 to play sound while app is open
    NSString *path = [NSString stringWithFormat:@"%@/Bell.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
  
  [self constructDirectionsRequest];
  
  
}

-(void)constructDirectionsRequest{
  NSString *origin = [NSString stringWithFormat:@"%f,%f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
  NSString *destination = @"";
  NSString *key = @"";
  NSString *jsonURLRequest = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=MetLife+Stadium+1+MetLife+Stadium+Dr+East+Rutherford,+NJ+07073&mode=transit&key=%@",origin,key];
  
  
  NSURL *url = [NSURL URLWithString: jsonURLRequest];
  
  //GET request is below
  NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"GET"];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                          completionHandler:
                                ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  NSLog(@"Got response %@ with error %@.\n", response, error);
                                  NSLog(@"DATA:\n%@\nEND DATA\n",
                                        [[NSString alloc] initWithData: data
                                                              encoding: NSUTF8StringEncoding]);
                                  
                                  
                                  NSDictionary *jsonDataFile  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                  NSLog(@"%@",jsonDataFile);
                                      }];
  
  
  [task resume];
}


//function to log user location for debugging and troubleshooting
- (NSString *)deviceLocation
{
  NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
  return theLocation;
}

-(void)logLocation{
  NSLog(@"%@", [self deviceLocation]);
}

//CLLocationManager method for gathering location into array and updating based on user movement
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  self.currentLocation = [locations lastObject];
  NSDate *eventDate = self.currentLocation.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  if (fabs(howRecent) < 15.0) {
    // Update your marker on your map using location.coordinate.latitude
    //and location.coordinate.longitude);
    
  }
  NSLog(@"%@", [self deviceLocation]);
  [self checkDistance];

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

#pragma map marker methods

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

//check user distance to trigger
-(void)checkDistance{
  //user values
  double userLatDouble = self.currentLocation.coordinate.latitude;
  double userLongDouble = self.currentLocation.coordinate.longitude;
  
  //trigger values
  double endLatDouble = 40.741408;
  double endLongDouble = -73.989561;
  
  //set radius in meters
  double radiusDouble = 1;
  
  CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userLatDouble longitude:userLongDouble];
  CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:endLatDouble longitude:endLongDouble];
  double distanceMeters = [userLocation distanceFromLocation:endLocation];
  
  NSLog(@"Radius allowed in kilometers is: %.2f", radiusDouble/1000);
  NSLog(@"Actual distance between parent and child in kilometers is: %.2f", distanceMeters);
  NSLog(@"%@", [self deviceLocation]);
  
  if (distanceMeters <= (radiusDouble/1000)){
    [self soundTheAlarm];
  }
  
}

-(void)soundTheAlarm{
  UILocalNotification* localNotification = [[UILocalNotification alloc] init];
  localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
  localNotification.alertBody = @"You need to get off the bus, Chad.";
  localNotification.timeZone = [NSTimeZone defaultTimeZone];
  [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
  localNotification.soundName = @"Bell.mp3";
  [self.audioPlayer play];
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
