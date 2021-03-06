//
//  SettingViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/27/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonMethods.h"
#import "AnnotationMaker.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.txtFieldName.text = [[PFUser currentUser] objectForKey:@"name"];
    [self.segmentControllerType setSelectedSegmentIndex:[[[PFUser currentUser] objectForKey:@"alignment"] intValue]];
    latitude = -1;
    longitude = -1;
    PFGeoPoint *objPoint = [[PFUser currentUser] objectForKey:@"location"];
    if(objPoint)
    {
        AnnotationMaker *Annotation1=[[AnnotationMaker alloc] initWithTitle:@"My Location" withSubTitle:@"Having fun...!" andCoordinate:CLLocationCoordinate2DMake(objPoint.latitude, objPoint.longitude)];
    
        [self.locationMap addAnnotation:Annotation1];
    
        //NSLog(@"Annotation Count::%d",[self.BusinessMap.annotations count]);
        [self zoomMapViewToFitAnnotations:self.locationMap animated:YES];
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UpdationLocationAction:(id)sender
{
    [locationManager startUpdatingLocation];
}
- (IBAction)doneAction:(id)sender
{
    if([CommonMethods countStringLength:self.txtFieldName.text].length>0)
    {
        PFUser *objPFUser = [PFUser currentUser];
        objPFUser[@"alignment"] = [NSNumber numberWithInt:self.segmentControllerType.selectedSegmentIndex];
        objPFUser[@"name"] = self.txtFieldName.text;
        if(latitude!=-1 && longitude !=-1)
        {
            objPFUser[@"location"] = [PFGeoPoint geoPointWithLatitude:latitude longitude:-longitude];
        }
        [objPFUser saveInBackground];
        [self.delegate settingViewControllerDone:self.segmentControllerType.selectedSegmentIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Name field can't be empty"];
    }
}
- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setViewAccordingToOrientations
{
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    [self.view endEditing:YES];
    if (orientation==UIInterfaceOrientationPortrait)
    {
        self.txtFieldName.frame = CGRectMake(25, 90, 265, 30);
        self.segmentControllerType.frame = CGRectMake(31, 130, 258, 29);
        self.btnUpdateLocation.frame = CGRectMake(40, 170, 249, 30);
        
        if(g_IS_IPHONE_4_SCREEN)
        {
             self.locationMap.frame = CGRectMake(20, 210, 280, 250);
        }
        else
        {
             self.locationMap.frame = CGRectMake(20, 210, 280, 340);
        }
        
       
        
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        float txtfiledXPos = 151;
        float segnType = 154;
        float btnUpdate = 159;
        float locationWidth = 528;
        
        if(g_IS_IPHONE_4_SCREEN)
        {
             txtfiledXPos = 100;
             segnType = 104;
             btnUpdate = 109;
             locationWidth = 440;
        }
       
        
        self.txtFieldName.frame = CGRectMake(txtfiledXPos, 73, 266, 30);
        self.segmentControllerType.frame = CGRectMake(segnType, 113, 260, 29);
        self.btnUpdateLocation.frame = CGRectMake(btnUpdate, 148, 250, 30);
        self.locationMap.frame = CGRectMake(20, 180, locationWidth, 130);
        
        
    }
    
}
- (BOOL)shouldAutorotate
{
    [self setViewAccordingToOrientations];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self setViewAccordingToOrientations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark LocationManager Delegates
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", [newLocation description]);
    [locationManager stopUpdatingLocation];
    
    AnnotationMaker *Annotation1=[[AnnotationMaker alloc] initWithTitle:@"My Location" withSubTitle:@"Having fun...!" andCoordinate:newLocation.coordinate];
    
    [self.locationMap addAnnotation:Annotation1];
    
    //NSLog(@"Annotation Count::%d",[self.BusinessMap.annotations count]);
    [self zoomMapViewToFitAnnotations:self.locationMap animated:YES];
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [CommonMethods showAlertView:@"Allow Location Service" Message:@"Goto 1. Settings 2. Privacy 3. Location Services 4. Set ChallengeProject to ON"];
	NSLog(@"Error: %@", [error description]);
}
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView1 animated:(BOOL)animated
{
    NSArray *annotations = mapView1.annotations;
    int count = [mapView1.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    
    [self.locationMap setRegion:region animated:animated];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *parkingAnnotationIdentifier=@"ParkingAnnotationIdentifier";
    
    if([annotation isKindOfClass:[AnnotationMaker class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:parkingAnnotationIdentifier];
        //If one isn't available, create a new one
        if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier];
            
            // annotationView.image=[UIImage imageNamed:@"Checkin-icon-.png"];
        }
        return annotationView;
    }
    return nil;
}
@end
