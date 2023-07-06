//
//  MainCoordinatorView.swift
//  Cafe
//
//  Created by MinKyeongTae on 2023/05/26.
//  Copyright © 2023 com.cafe. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MainCoordinatorView: View {
  let store: StoreOf<MainCoordinator>

  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        mainView
        tabBarView

        IfLetStore(
          store.scope(
            state: \.filterSheetState,
            action: MainCoordinator.Action.filterSheetAction
          ),
          then: FilterBottomSheetView.init
        )

        IfLetStore(
          store.scope(
            state: \.toastMessageState,
            action: MainCoordinator.Action.toastMessage
          ),
          then: ToastView.init
        )

        IfLetStore(
          store.scope(
            state: \.bubbleMessageState,
            action: MainCoordinator.Action.bubbleMessage
          ),
          then: BubbleMessageView.init
        )
        .onTapGesture {
          viewStore.send(.dismissBubbleMessageView)
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }

  var mainView: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        NavigationView {
          SearchCoordinatorView(
            store: store.scope(
              state: \.searchState,
              action: MainCoordinator.Action.search
            )
          )
          .background(.white)

        }
        .zIndex(viewStore.selectedTab == .search ? 100 : 0)

        NavigationView {
          SavedListCoordinatorView(
            store: store.scope(
              state: \.savedListState,
              action: MainCoordinator.Action.savedList
            )
          )
          .background(.white)
        }
        .zIndex(viewStore.selectedTab == .savedList ? 100 : 0)

        NavigationView {
          MyPageCoordinatorView(
            store: store.scope(
              state: \.myPageState,
              action: MainCoordinator.Action.myPage
            )
          )
          .background(.white)

        }
        .zIndex(viewStore.selectedTab == .myPage ? 100 : 0)
      }
    }
  }

  var tabBarView: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Spacer()
        TabBarView(
          store: store.scope(
            state: \.tabBarState,
            action: MainCoordinator.Action.tabBar
          )
        )
      }
    }
  }
}

struct MainCoordinatorView_Previews: PreviewProvider {
  static var previews: some View {
    MainCoordinatorView(
      store: .init(
        initialState: .initialState,
        reducer: MainCoordinator()
      )
    )
  }
}
