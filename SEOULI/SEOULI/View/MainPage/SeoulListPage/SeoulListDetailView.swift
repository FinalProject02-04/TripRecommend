//
//  SeoulListDetailVIew.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.

/*
 Author : Diana
 Date : 2024.06.26 Wednesday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 */

import SwiftUI
import MapKit

struct SeoulListDetailView: View {
    var location : SeoulList
    @State private var mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    var body: some View {
            ZStack {
                Image(location.imageName)
                    .resizable()
                    .frame(width: 490, height: 380)
                    .padding(.bottom, 550)

                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 400, height: 650)
                        .padding(.top, 300)
                        .shadow(radius: 10)
                        .overlay(
                            ScrollView {
                                VStack(alignment: .leading) {
                                    // 장소명
                                    Text(location.name)
                                        .font(.system(size: 36))
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(.top, 20)
                                        .padding(.bottom, 2)

                                    // FIXED
                                    Text("Seoul")
                                        .font(.title)
                                        .padding(.trailing, 270)

                                    Spacer()

                                    // 상세
                                    Text(location.description)

                                    Spacer(minLength: 40)

                                    // 지도 (Map API 사용)
                                    Map(coordinateRegion: $mapRegion, annotationItems: [location]) { location in
                                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), tint: .red)
                                    }
                                    .frame(width: 350, height: 350, alignment: .center)

                                    Spacer(minLength: 40)

                                    // 문의 및 안내
                                    HStack {
                                        Image(systemName: "phone.fill")
                                        Text("문의 및 안내 ")
                                            .bold()
                                        Text(location.inquiries)
                                    }

                                    Spacer()

                                    // 상세 주소
                                    HStack {
                                        Image(systemName: "mappin.circle")
                                        Text("주소             ")
                                            .bold()
                                        Text(location.address)
                                    }
                                } // VStack
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } // ScrollView
                            .frame(width: 380, height: 610)
                            .padding(.top, 250) 
                        ) // overlay
                }
            } // ZStack
        } // body
    } // view

#Preview {
    SeoulListDetailView(location: SeoulList(name: "위례신도시 1", imageName: "background3", description: "동대문문화원은 서울 동대문구에 위치한 주요 문화 기관입니다. 이 기관은 지역 문화와 유산을 보존하고 홍보하는 중심지 역할을 합니다. 동대문문화원은 전통 한국 예술, 공예, 음악, 춤 등을 선보이는 다양한 문화 행사, 교육 프로그램, 전시회를 개최합니다. 또한 지역 주민과 방문객들에게 문화적 정체성과 공동체 의식을 함양할 수 있는 자원과 공간을 제공합니다. ", address: "위례대로 6길 20",inquiries: "010-1111-1111"))
}

