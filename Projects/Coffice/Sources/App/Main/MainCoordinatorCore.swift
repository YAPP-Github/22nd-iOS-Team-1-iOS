//
//  MainCoordinatorCore.swift
//  Cafe
//
//  Created by MinKyeongTae on 2023/05/26.
//  Copyright © 2023 com.cafe. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

// MARK: - MainCoordniatorCore

struct MainCoordinator: ReducerProtocol {
  struct State: Equatable {
    static let initialState = MainCoordinator.State(
      homeState: .initialState,
      searchState: .initialState,
      savedListState: .initialState,
      myPageState: .initialState,
      tabBarState: .init()
    )

    var homeState: HomeCoordinator.State
    var searchState: SearchCoordinator.State
    var savedListState: SavedListCoordinator.State
    var myPageState: MyPageCoordinator.State
    var tabBarState: TabBar.State
    var selectedTab: TabBar.State.TabBarItemType {
      tabBarState.selectedTab
    }

    var bubbleMessageViewState: BubbleMessageViewState?
    var isBubbleMessageViewPresented: Bool {
      return bubbleMessageViewState != nil
    }
  }

  enum Action: Equatable {
    case home(HomeCoordinator.Action)
    case search(SearchCoordinator.Action)
    case savedList(SavedListCoordinator.Action)
    case myPage(MyPageCoordinator.Action)
    case tabBar(TabBar.Action)
    case dismissBubbleMessageView
    case onAppear
  }

  var body: some ReducerProtocolOf<MainCoordinator> {
    Scope(state: \State.homeState, action: /Action.home) {
      HomeCoordinator()
    }

    Scope(state: \State.searchState, action: /Action.search) {
      SearchCoordinator()
    }

    Scope(state: \State.savedListState, action: /Action.savedList) {
      SavedListCoordinator()
    }

    Scope(state: \State.myPageState, action: /Action.myPage) {
      MyPageCoordinator()
    }

    Scope(state: \State.tabBarState, action: /Action.tabBar) {
      TabBar()
    }

    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none

      case let .tabBar(.selectTab(itemType)):
        debugPrint("selectedTab : \(itemType)")
        return .none

      case .search(.routeAction(_, .cafeSearchDetail(.presentBubbleMessageView(let viewState)))):
        state.bubbleMessageViewState = viewState
        return .none

      case .dismissBubbleMessageView:
        state.bubbleMessageViewState = nil
        return .none

      default:
        return .none
      }
    }
  }
}

extension MainCoordinator.State {
  struct BubbleMessageViewState: Equatable {
    let title: String
    let subTitle: String
    let subInfoViewStates: [BubbleMessageSubInfoViewState]
  }

  struct BubbleMessageSubInfoViewState: Equatable, Identifiable {
    let id = UUID()
    let iconImage: CofficeImages
    let title: String
    let description: String
  }
}
