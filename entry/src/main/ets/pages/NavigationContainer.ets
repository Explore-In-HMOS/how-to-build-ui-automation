import { FormPageBuilder } from './FormPage'
import { GesturePageBuilder } from './GesturePage'
import { IndexPageBuilder } from './Index'

export class NavigationPaths {
  static INDEX_PAGE: string = 'Index'
  static FORM_PAGE: string = 'FormPage'
  static GESTURE_PAGE: string = 'GesturePage'
}

@Entry
@Component
struct NavigationContainer {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string, param: object) {
    if(name === NavigationPaths.INDEX_PAGE) {
      IndexPageBuilder()
    } else if (name === NavigationPaths.GESTURE_PAGE) {
      GesturePageBuilder()
    } else if (name === NavigationPaths.FORM_PAGE) {
      FormPageBuilder()
    }
  }

  aboutToAppear(): void {
    this.pageStack.replacePathByName(NavigationPaths.INDEX_PAGE, null)
  }

  build() {
    Navigation(this.pageStack) {

    }
      .mode(NavigationMode.Stack)
      .navDestination(this.pageMap)
      .hideTitleBar(true)
  }
}