//
//  CafeCardView.swift
//  coffice
//
//  Created by sehooon on 2023/06/26.
//  Copyright © 2023 kr.co.yapp. All rights reserved.
//

import SwiftUI

struct CafeCardView: View {
  var body: some View {
    Rectangle()
      .foregroundColor(Color(asset: CofficeAsset.Colors.grayScale1))
      .cornerRadius(12, corners: [.topLeft, .topRight])
      .shadow(color: .gray, radius: 2, x: 0, y: 0)
      .overlay {
        VStack(alignment: .leading, spacing: 0) {
          HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
              HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("훅스턴")
                  .applyCofficeFont(font: CofficeFont.header2)
                  .foregroundColor(Color(asset: CofficeAsset.Colors.grayScale9))
                Text("서울 서대문구")
                  .applyCofficeFont(font: .body2Medium)
                  .foregroundColor(Color(asset: CofficeAsset.Colors.grayScale7))
              }
              HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("영업중")
                  .applyCofficeFont(font: .button)
                  .foregroundColor(Color(asset: CofficeAsset.Colors.secondary1))
                Text("월: 11:00 ~23:00")
                  .applyCofficeFont(font: .body1Medium)
                  .foregroundColor(Color(asset: CofficeAsset.Colors.grayScale7))
              }
            }
            Spacer()
            Button {

            } label: {
              Image(uiImage: CofficeAsset.Asset.bookmarkLine40px.image)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
            }
          }
          .padding(EdgeInsets(top: 24, leading: 20, bottom: 16, trailing: 20))
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(1...10, id: \.self) { _ in
                Image(uiImage: CofficeAsset.Asset.cafeImage.image)
                  .resizable()
                  .frame(width: 124, height: 112)
                  .cornerRadius(4, corners: .allCorners)
                  .scaledToFit()
                  .padding(.trailing, 8)
              }
            }
          }
          .padding(EdgeInsets(top: 0, leading: 20, bottom: 16, trailing: 20))
          HStack {
            Text("🔌 콘센트 넉넉")
              .applyCofficeFont(font: .body2Medium)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .overlay(
                RoundedRectangle(cornerRadius: 4)
                  .stroke(
                    Color(asset: CofficeAsset.Colors.grayScale3),
                    lineWidth: 1
                  )
              )
          }
          .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0))
        }
      }
  }
}

struct CafeCardView_Previews: PreviewProvider {
  static var previews: some View {
    CafeCardView()
  }
}
