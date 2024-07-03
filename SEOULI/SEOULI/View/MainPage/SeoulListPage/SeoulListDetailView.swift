//
//  SeoulListDetailVIew.swift
//  SEOULI
//
//  Created by 김수민 on 6/25/24.

/*
 Author : 김수민
 
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업
 
 Date : 2024.07.02 Tuesday
 Description : DB 연결, MapKit이용해 Map생성
 */

import SwiftUI
import MapKit

struct SeoulListDetailView: View {
    var location: SeoulList
    
    // Map region state
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Geocoder instance to convert address to coordinates
    let geocoder = CLGeocoder()
    
    // Coordinates for the location
    @State private var locationCoordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
    
    // State to track if the annotation is selected
    @State private var isAnnotationSelected = false
    
    var body: some View {
        ZStack {
            // Background image or placeholder
            AsyncImage(url: URL(string: location.imageName)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 700)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.bottom , 400)
            
            // Main content container
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(width: 400, height: 770)
                    .padding(.top, 300)
                    .shadow(radius: 10)
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading) {
                                // Place name
                                Text(location.name)
                                    .font(.system(size: 36))
                                    .bold()
                                    .foregroundColor(Color("Text Color"))
                                    .padding(.top, 20)
                                    .padding(.bottom, 1)
                                
                                Text("Seoul")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Text Color"))
                                
                                Spacer()
                                
                                // Description
                                Text(location.description)
                                    .foregroundColor(Color("Text Color"))
                                
                                Spacer(minLength: 40)
                                
                                // Map (MAPKIT)
                                Map(coordinateRegion: $mapRegion, annotationItems: [location]) { location in
                                    MapAnnotation(coordinate: locationCoordinate) {
                                        Button(action: {
                                            isAnnotationSelected.toggle()
                                        }) {
                                            VStack {
                                                Image(systemName: "mappin.circle.fill")
                                                    .foregroundColor(.pink)
                                                    .font(.system(size: 32))
                                                Text(location.name)
                                                    .foregroundColor(.black)
                                                    .font(.caption)
                                                    .bold()
                                                    .padding(4)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                                    .padding(4)
                                            }
                                        }
                                        if isAnnotationSelected {
                                            VStack {
                                                Text(location.address)
                                                    .foregroundColor(.black)
                                                    .font(.caption)
                                                    .padding(4)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                                    .padding(.top, 87)
                                                    .bold()
                                            }
                                        }
                                    }
                                }
                                .frame(width: 350, height: 350, alignment: .center)
                                .onAppear {
                                    // Geocode the address
                                    geocoder.geocodeAddressString(location.address) { placemarks, error in
                                        guard let placemark = placemarks?.first, let location = placemark.location else {
                                            print("Error geocoding address")
                                            return
                                        }
                                        locationCoordinate = location.coordinate
                                        mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                                    }
                                }
                                
                                Spacer(minLength: 40)
                                
                                // Contact information
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(Color("Text Color"))
                                    Text("문의 및 안내 ")
                                        .bold()
                                        .foregroundColor(Color("Text Color"))
                                    Text(location.inquiries)
                                        .foregroundColor(Color("Text Color"))
                                }
                                
                                Spacer()
                                
                                // Address
                                HStack {
                                    Image(systemName: "mappin.circle")
                                        .foregroundColor(Color("Text Color"))
                                    Text("주소       ")
                                        .bold()
                                        .foregroundColor(Color("Text Color"))
                                    Text(location.address)
                                        .foregroundColor(Color("Text Color"))
                                }
                                
                                Spacer()
                                    .frame(height: 160)
                                
                            } // VStack
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } // ScrollView
                        .frame(width: 380, height: 678)
                        .padding(.top, 210)
                    ) // Overlay
            } // ZStack
        } // ZStack
    } // Body
} // View

#Preview {
    SeoulListDetailView(location: SeoulList(id: UUID(), name: "Test Location", address: "Test Address", description: "Test Description", inquiries: "010-1111-1111", imageName: "https://cdn.visitkorea.or.kr/img/call?cmd=VIEW&id=a41eaf7e-7ccf-4e61-9496-7928c6f5a0e5"))
}
