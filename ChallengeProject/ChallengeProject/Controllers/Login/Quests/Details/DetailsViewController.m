//
//  DetailsViewController.m
//  ChallengeProject
//
//  Created by Faizan on 4/26/14.
//  Copyright (c) 2014 MYRIAD. All rights reserved.
//

#import "DetailsViewController.h"
#import "CommonMethods.h"
#import "AnnotationMaker.h"
#import <Parse/Parse.h>

@interface DetailsViewController ()

@end

@implementation DetailsViewController

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
    self.txtFieldHeading.text = self.objQuest.title;
    self.lblPosted.text = [NSString stringWithFormat:@"Posted By: %@",[self.objQuest.objOwner objectForKey:@"name"]];
    self.txtFieldDetails.text  = self.objQuest.Details;
    objQuestHandler = [[QuestHandler alloc] init];
    objQuestHandler.delegate = self;
    
    AnnotationMaker *Annotation1=[[AnnotationMaker alloc] initWithTitle:@"Quest Location" withSubTitle:@"Having fun...!" andCoordinate:CLLocationCoordinate2DMake(self.objQuest.location.latitude, self.objQuest.location.longitude)];
    Annotation1.type = 0;
    
    [self.mapLocation addAnnotation:Annotation1];
    
    PFGeoPoint *objOwnerPoints = [self.objQuest.objOwner objectForKey:@"location"];
    
    AnnotationMaker *Annotation2=[[AnnotationMaker alloc] initWithTitle:@"My Location" withSubTitle:@"Having fun...!" andCoordinate:CLLocationCoordinate2DMake(objOwnerPoints.latitude, objOwnerPoints.longitude)];
    Annotation1.type = 1;
    
    [self.mapLocation addAnnotation:Annotation2];
    [self zoomMapViewToFitAnnotations:self.mapLocation animated:YES];
    if(self.objQuest.isAccepted)
    {
        [self.btnAccepted setTitle:@"Complete" forState:UIControlStateNormal];
        [self.btnAccepted setTitle:@"Complete" forState:UIControlStateHighlighted];
    }
    if(self.objQuest.isCompleted)
    {
        self.objQuest.isCompleted = YES;
        self.btnAccepted.hidden = YES;
        self.btnAccepted.enabled = NO;
    }
    self.imgViewQuest.image = [UIImage imageNamed:placeHolderImage];
    self.imgViewQuest.imageURL = self.objQuest.imageURL;
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
     [self setViewAccordingToOrientations];    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)MapTypeChangeAction:(id)sender
{
  
    self.mapLocation.mapType = self.segmentMapType.selectedSegmentIndex;
    
}

- (IBAction)acceptedAction:(id)sender
{
    if(!self.objQuest.isAccepted)
    {
        [objQuestHandler QuestAcceptCall:self.objQuest];
    }
    else
    {
        [objQuestHandler QuestCompleteCall:self.objQuest];
    }
}
-(void)setViewAccordingToOrientations
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    [self.view endEditing:YES];
    if (orientation==UIInterfaceOrientationPortrait)
    {
        self.imgViewQuest.frame = CGRectMake(4, 68, 100, 100);
        self.txtFieldHeading.frame = CGRectMake(110, 67, 205, 62);
        self.txtFieldDetails.frame = CGRectMake(5, 172, 310, 140);
        self.lblPosted.frame =CGRectMake(111, 131, 205, 33);
        self.segmentMapType.frame = CGRectMake(34, 322, 247, 29);
        self.imgViewQuest.frame = CGRectMake(5, 68, 100, 100);
        if(g_IS_IPHONE_4_SCREEN)
        {
            self.mapLocation.frame = CGRectMake(5, 361, 310, 112);
        }
        else
        {
             self.mapLocation.frame = CGRectMake(5, 361, 310, 180);
        }
       
       
    }
    else if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        CGRect imgViewQuestFrame = CGRectMake(5, 80, 100, 100);
        CGRect txtFieldHeadingFrame = CGRectMake(110, 70, 448, 35);
        CGRect txtFieldDetailsFrame = CGRectMake(110, 131,448, 68);
        CGRect lblPostFrame = CGRectMake(113, 109, 442, 20);
        CGRect segmentMapFrame = CGRectMake(155, 205, 247, 29);
        CGRect mapLocationFrame = CGRectMake(5, 240, 558, 73);
       
        if(g_IS_IPHONE_4_SCREEN)
        {
            txtFieldHeadingFrame.origin.x = 110;
            txtFieldHeadingFrame.size.width = 380;
            
            txtFieldDetailsFrame.origin.x = 110;
            txtFieldDetailsFrame.size.width = 380;
            
            lblPostFrame.origin.x = 113;
            lblPostFrame.size.width = 378;
            
            mapLocationFrame.size.width = 470;
            
            
        }
    
        self.imgViewQuest.frame = imgViewQuestFrame;
        self.txtFieldHeading.frame = txtFieldHeadingFrame;
        self.txtFieldDetails.frame = txtFieldDetailsFrame;
        self.lblPosted.frame = lblPostFrame;
        self.segmentMapType.frame = segmentMapFrame;
        self.mapLocation.frame = mapLocationFrame;
    }
}
- (BOOL)shouldAutorotate {
    
    [self setViewAccordingToOrientations];
    
    return YES;
}
#pragma mark QuestHandlerDelegates
-(void)questAcceptedDone:(BOOL)status
{
    if(status)
    {
        [self.btnAccepted setTitle:@"Complete" forState:UIControlStateNormal];
        [self.btnAccepted setTitle:@"Complete" forState:UIControlStateHighlighted];
        self.objQuest.isAccepted = YES;
    }
}
-(void)questCompleteDone:(BOOL)status
{
    if(status)
    {
        self.objQuest.isCompleted = YES;
        self.btnAccepted.hidden = YES;
        self.btnAccepted.enabled = NO;
    }
}

#pragma mark MapDelegatesAndFunctions

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
    
    [self.mapLocation setRegion:region animated:animated];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *parkingAnnotationIdentifier=@"ParkingAnnotationIdentifier";
    
    if([annotation isKindOfClass:[AnnotationMaker class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:parkingAnnotationIdentifier];
        //If one isn't available, create a new one
        if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier];
            if(((AnnotationMaker*)annotation).type == 0)
            {
                AsyncImageView *imageView = [[AsyncImageView alloc] initWithImage:[UIImage imageNamed:placeHolderImage]];
                imageView.frame = CGRectMake(0, 0, 30, 30);
                imageView.imageURL = self.objQuest.imageURL;
                [annotationView addSubview:imageView] ;
                
                
            }
            else
            {
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:placeHolderImage]];
               
                if([[PFUser currentUser] objectForKey:@"customUserImage"] && [[PFUser currentUser] objectForKey:@"customUserImage"]!= [NSNull null])
                {
                    PFFile *userImageFile = [PFUser currentUser][@"customUserImage"];
                    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            imgView.image = [UIImage imageWithData:imageData];
                        }
                    }];
                }
                imgView.frame = CGRectMake(0, 0, 30, 30);
                imgView.clipsToBounds = YES;
                imgView.layer.cornerRadius = imgView.bounds.size.height/2;//half of the width
                imgView.layer.borderColor=[UIColor clearColor].CGColor;
                [annotationView addSubview:imgView] ;
                //annotationView.image = [UIImage imageNamed:@"userpin.png"];
            }
            // annotationView.image=[UIImage imageNamed:@"Checkin-icon-.png"];
        }
        return annotationView;
    }
    return nil;
}

@end
