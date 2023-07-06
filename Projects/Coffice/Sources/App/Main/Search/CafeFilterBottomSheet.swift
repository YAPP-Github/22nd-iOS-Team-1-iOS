//
//  CafeFilterBottomSheet.swift
//  coffice
//
//  Created by sehooon on 2023/06/27.
//  Copyright © 2023 kr.co.yapp. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct CafeFilterBottomSheet: ReducerProtocol {
  typealias OptionType = CafeFilterOptionButtonViewState.OptionType
  typealias RunningTimeOption = CafeFilterOptionButtonViewState.RunningTimeOption
  typealias OutletOption = CafeFilterOptionButtonViewState.OutletOption
  typealias SpaceSizeOption = CafeFilterOptionButtonViewState.SpaceSizeOption
  typealias PersonnelOption = CafeFilterOptionButtonViewState.PersonnelOption
  typealias FoodOption = CafeFilterOptionButtonViewState.FoodOption
  typealias ToiletOption = CafeFilterOptionButtonViewState.ToiletOption
  typealias DrinkOption = CafeFilterOptionButtonViewState.DrinkOption

  struct State: Equatable {
    static var mock: Self {
      .init(filterType: .detail)
    }

    let filterType: CafeFilterType
    var mainViewState: CafeFilterBottomSheetViewState = .init(optionButtonCellViewStates: [])

    init(filterType: CafeFilterType) {
      self.filterType = filterType

      switch filterType {
      case .detail:
        mainViewState = .init(
          optionButtonCellViewStates: [
            runningTimeOptionButtonCellViewState,
            outletOptionButtonCellViewState,
            spaceSizeOptionButtonCellViewState,
            personnelOptionButtonCellViewState,
            foodOptionButtonCellViewState,
            toiletOptionButtonCellViewState,
            drinkOptionButtonCellViewState
          ]
        )
      case .runningTime:
        mainViewState = .init(optionButtonCellViewStates: [runningTimeOptionButtonCellViewState])
      case .outlet:
        mainViewState = .init(optionButtonCellViewStates: [outletOptionButtonCellViewState])
      case .spaceSize:
        mainViewState = .init(optionButtonCellViewStates: [spaceSizeOptionButtonCellViewState])
      case .personnel:
        mainViewState = .init(optionButtonCellViewStates: [personnelOptionButtonCellViewState])
      }
    }

    // TODO: 음료, 화장실, 단체석, 푸드 구현
    var runningTimeOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: RunningTimeOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .runningTime($0), buttonTitle: $0.title)
        }
      )
    }

    var outletOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: OutletOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .outlet($0), buttonTitle: $0.title)
        }
      )
    }

    var spaceSizeOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: SpaceSizeOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .spaceSize($0), buttonTitle: $0.title)
        }
      )
    }

    var personnelOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: PersonnelOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .personnel($0), buttonTitle: $0.title)
        }
      )
    }

    var foodOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: FoodOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .food($0), buttonTitle: $0.title)
        }
      )
    }

    var toiletOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: ToiletOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .toilet($0), buttonTitle: $0.title)
        }
      )
    }

    var drinkOptionButtonCellViewState: CafeFilterOptionButtonCellViewState {
      CafeFilterOptionButtonCellViewState(
        viewStates: DrinkOption.allCases.map {
          CafeFilterOptionButtonViewState(optionType: .drink($0), buttonTitle: $0.title)
        }
      )
    }

    var shouldShowSubSectionView: Bool {
      return filterType == .detail
    }

    var bottomSheetHeight: CGFloat {
      filterType == .detail ? 660 : 240
    }
  }

  enum Action: Equatable {
    case findTappedButton(UUID)
    // TODO: filterButton 적용, 초기화
    case optionButtonTapped(collectionIndex: Int, optionType: OptionType)
    case filterOptionRequest
    case dismiss
    case searchPlaces
    case searchPlacesResponse(TaskResult<Int>)
    case resetFilter(CafeFilterType)
    case infoGuideButtonTapped
    case presentBubbleMessageView(BubbleMessage.State)
  }

  @Dependency(\.placeAPIClient) private var placeAPIClient

  var body: some ReducerProtocolOf<CafeFilterBottomSheet> {
    Reduce { state, action in
      switch action {
      case let .optionButtonTapped(collectionIndex, optionType):
        state.mainViewState
          .optionButtonCellViewStates[collectionIndex].viewStates[optionType.index]
          .isSelected
          .toggle()
        return .none

      case .infoGuideButtonTapped:
        // TODO: 상세 필터 타입에 맞게 말풍선뷰 표출 필요
        return EffectTask(value: .presentBubbleMessageView(.mock))

      default:
        return .none
      }
    }
  }
}

struct CafeFilterBottomSheetViewState: Equatable {
  var optionButtonCellViewStates: [CafeFilterOptionButtonCellViewState]

  init(optionButtonCellViewStates: [CafeFilterOptionButtonCellViewState]) {
    self.optionButtonCellViewStates = optionButtonCellViewStates
  }
}

struct CafeFilterOptionButtonViewState: Equatable, Identifiable {
  enum OptionType: Equatable {
    /// 영업시간
    case runningTime(RunningTimeOption)
    /// 콘센트
    case outlet(OutletOption)
    /// 공간크기
    case spaceSize(SpaceSizeOption)
    /// 단체석
    case personnel(PersonnelOption)
    /// 푸드
    case food(FoodOption)
    /// 화장실
    case toilet(ToiletOption)
    /// 음료
    case drink(DrinkOption)

    var index: Int {
      switch self {
      case .runningTime(let option):
        return option.index
      case .outlet(let option):
        return option.index
      case .spaceSize(let option):
        return option.index
      case .personnel(let option):
        return option.index
      case .food(let option):
        return option.index
      case .toilet(let option):
        return option.index
      case .drink(let option):
        return option.index
      }
    }
  }

  enum OutletOption: Int, Equatable, CaseIterable {
    case many
    case several
    case few

    var sectionTitle: String {
      return "콘센트"
    }

    var title: String {
      switch self {
      case .many: return "넉넉"
      case .several: return "보통"
      case .few: return "부족"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  enum RunningTimeOption: Int, Equatable, CaseIterable {
    case viewOnMap
    case running
    case twentyFourHours

    var sectionTitle: String {
      return "영업시간"
    }

    var title: String {
      switch self {
      case .viewOnMap:
        return "🕐 지도에서 보기"
      case .running:
        return "영업중"
      case .twentyFourHours:
        return "24시간"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  enum SpaceSizeOption: Int, Equatable, CaseIterable {
    case large
    case midium
    case small

    var sectionTitle: String {
      return "공간크기"
    }

    var title: String {
      switch self {
      case .large:
        return "대형카페"
      case .midium:
        return "중형카페"
      case .small:
        return "소형카페"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  enum PersonnelOption: Int, Equatable, CaseIterable {
    case groupSeat

    var sectionTitle: String {
      return "단체석"
    }

    var title: String {
      return "단체석"
    }

    var index: Int {
      return rawValue
    }
  }

  enum FoodOption: Int, Equatable, CaseIterable {
    case desert
    case mealAvailable

    var sectionTitle: String {
      return "푸드"
    }

    var title: String {
      switch self {
      case .desert:
        return "디저트"
      case .mealAvailable:
        return "식사가능"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  enum ToiletOption: Int, Equatable, CaseIterable {
    case indoors
    case genderSeparated

    var sectionTitle: String {
      return "화장실"
    }

    var title: String {
      switch self {
      case .indoors:
        return "실내"
      case .genderSeparated:
        return "남녀개별"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  enum DrinkOption: Int, Equatable, CaseIterable {
    case decaf
    case soyMilk

    var sectionTitle: String {
      return "음료"
    }

    var title: String {
      switch self {
      case .decaf:
        return "디카페인"
      case .soyMilk:
        return "두유"
      }
    }

    var index: Int {
      return rawValue
    }
  }

  let id = UUID()
  var option: OptionType
  var buttonTitle: String = ""
  var savedTappedState: Bool = false
  var isSelected: Bool = false
  var foregroundColor: CofficeColors {
    if isSelected {
      return CofficeAsset.Colors.grayScale1
    } else {
      return CofficeAsset.Colors.grayScale7
    }
  }
  var backgroundColor: CofficeColors {
    if isSelected {
      return CofficeAsset.Colors.grayScale9
    } else {
      return CofficeAsset.Colors.grayScale1
    }
  }
  var borderColor: CofficeColors {
    if isSelected {
      return CofficeAsset.Colors.grayScale9
    } else {
      return CofficeAsset.Colors.grayScale3
    }
  }

  init(optionType: OptionType, buttonTitle: String) {
    self.option = optionType
    self.buttonTitle = buttonTitle
  }
}

struct CafeFilterOptionButtonCellViewState: Equatable {
  let id = UUID()
  var viewStates: [CafeFilterOptionButtonViewState]
  var sectionTtile: String {
    switch viewStates.first?.option {
    case .runningTime(let option):
      return option.sectionTitle
    case .outlet(let option):
      return option.sectionTitle
    case .spaceSize(let option):
      return option.sectionTitle
    case .personnel(let option):
      return option.sectionTitle
    case .food(let option):
      return option.sectionTitle
    case .toilet(let option):
      return option.sectionTitle
    case .drink(let option):
      return option.sectionTitle
    case .none:
      return "-"
    }
  }
}

// 어떤 FilterSheet인지 구분하도록 FilterType 설정
enum CafeFilterType: CaseIterable {
  case detail
  case runningTime
  case outlet
  case spaceSize
  case personnel

  var title: String {
    switch self {
    case .detail: return "세부필터"
    case .runningTime: return "영업시간"
    case .outlet: return "콘센트"
    case .spaceSize: return "공간크기"
    case .personnel: return "단체석"
    }
  }

  var size: (width: CGFloat, height: CGFloat) {
    switch self {
    case .detail: return (width: 56, height: 36)
    case .runningTime: return (width: 91, height: 36)
    case .outlet: return (width: 79, height: 36)
    case .spaceSize: return (width: 91, height: 36)
    case .personnel: return (width: 69, height: 36)
    }
  }
}
