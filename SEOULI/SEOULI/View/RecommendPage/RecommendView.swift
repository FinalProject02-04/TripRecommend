import SwiftUI

struct RecommendView: View {
    @State private var selectedOption: String? = nil
    let options = ["남자", "여자"]
    @State private var navigateToNextView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("성별을 선택해 주세요")
                    .bold()
                    .padding()
                
                ForEach(options, id: \.self) { option in
                    SquareButton(selectedOption: $selectedOption, label: option)
                }
                
                Button("다음으로 가기") {
                    print(selectedOption ?? "No selection")
                    navigateToNextView = true
                }
                .padding()
                .navigationDestination(isPresented: $navigateToNextView) {
                    AgeSelect()
                }
                
            }
        }
        .navigationBarBackButtonHidden(true) // 뒤로가기 버튼 숨기기
        .navigationBarHidden(true) // 네비게이션 바 숨기기
    }
}

struct AgeSelect: View {
    @State private var navigateToNextView = false
    @State private var selectedOption: String? = nil
    let options = ["20대", "30대", "40대", "50대 이상"]
    
    var body: some View {
        VStack {
            Text("연령대를 선택해주세요")
                .bold()
                .padding()
            
            ForEach(options, id: \.self) { option in
                SquareButton(selectedOption: $selectedOption, label: option)
            }
            
            Button("다음으로 가기") {
                print(selectedOption ?? "No selection")
                navigateToNextView = true
            }
            .padding()
            .navigationDestination(isPresented: $navigateToNextView) {
                MotivationSelect()
            }
        }
    }
}

struct MotivationSelect: View {
    @State private var navigateToNextView = false
    @State private var selectedOption: String? = nil
    let options = ["일상적인 환경에서의 탈출", "육체적 정신적 휴식", "여행 동반자와의 친밀감 증진", "자아 찾기"]
    
    var body: some View {
        VStack {
            Text("여행 동기를 선택해 주세요")
                .bold()
                .padding()
            
            ForEach(options, id: \.self) { option in
                SquareButton(selectedOption: $selectedOption, label: option)
            }
            
            Button("다음으로 가기") {
                print(selectedOption ?? "No selection")
                navigateToNextView = true
            }
            .padding()
            .navigationDestination(isPresented: $navigateToNextView) {
                // 다음 뷰로 네비게이션 로직 추가
                ConpanionsSelect()
            }
        }
    }
}

struct ConpanionsSelect: View {
    @State private var navigateToNextView = false
    @State private var selectedOption: String? = nil
    let options = ["혼자", "동반 1인", "동반 2인", "동반 3인"]
    
    var body: some View {
        VStack {
            Text("여행 동반자 수를 선택해 주세요")
                .bold()
                .padding()
            
            ForEach(options, id: \.self) { option in
                SquareButton(selectedOption: $selectedOption, label: option)
            }
            
            Button("다음으로 가기") {
                print(selectedOption ?? "No selection")
                navigateToNextView = true
            }
            .padding()
            .navigationDestination(isPresented: $navigateToNextView) {
                // 다음 뷰로 네비게이션 로직 추가
                SeoulSelect()
            }
        }
    }
}

struct SeoulSelect: View {
    @State private var navigateToNextView = false
    @State private var selectedOption: String? = nil
    let options = ["종로구 (Jongno-gu)",
                   "중구 (Jung-gu)",
                   "용산구 (Yongsan-gu)",
                   "성동구 (Seongdong-gu)",
                   "광진구 (Gwangjin-gu)",
                   "동대문구 (Dongdaemun-gu)",
                   "중랑구 (Jungnang-gu)",
                   "성북구 (Seongbuk-gu)",
                   "강북구 (Gangbuk-gu)",
                   "도봉구 (Dobong-gu)",
                   "노원구 (Nowon-gu)",
                   "은평구 (Eunpyeong-gu)",
                   "서대문구 (Seodaemun-gu)",
                   "마포구 (Mapo-gu)",
                   "양천구 (Yangcheon-gu)",
                   "강서구 (Gangseo-gu)",
                   "구로구 (Guro-gu)",
                   "금천구 (Geumcheon-gu)",
                   "영등포구 (Yeongdeungpo-gu)",
                   "동작구 (Dongjak-gu)",
                   "관악구 (Gwanak-gu)",
                   "서초구 (Seocho-gu)",
                   "강남구 (Gangnam-gu)",
                   "송파구 (Songpa-gu)",
                   "강동구 (Gangdong-gu)"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("서울 25구 중 여행 갈 곳을 선택해 주세요")
                    .bold()
                    .padding()
                
                ScrollView {
                    VStack {
                        ForEach(options, id: \.self) { option in
                            SquareButton(selectedOption: $selectedOption, label: option)
                        }
                    }
                }
                
                Button("다음으로 가기") {
                    print(selectedOption ?? "No selection")
                    navigateToNextView = true
                }
                .padding()
                .navigationDestination(isPresented: $navigateToNextView) {
                    // 다음 뷰로 네비게이션 로직 추가
                    RecommendResultView()
                }
            }
            .padding()
        }
    }
}

struct SquareButton: View {
    @Binding var selectedOption: String?
    var label: String
    
    var body: some View {
        Button(action: {
            if selectedOption == label {
                selectedOption = nil
            } else {
                selectedOption = label
            }
        }) {
            Text(label)
                .padding()
                .frame(width: 350)
                .background(selectedOption == label ? Color.theme : Color.clear)
                .foregroundColor(selectedOption == label ? .white : .black.opacity(0.7))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.theme, lineWidth: selectedOption == label ? 0 : 2)
                )
        }
        .padding(10)
    }
}

#Preview {
    RecommendView()
}
