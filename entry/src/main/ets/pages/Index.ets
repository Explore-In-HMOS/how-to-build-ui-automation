import { NavigationPaths } from './NavigationContainer'

@Builder
export function IndexPageBuilder() {
  Index()
}

@Component
struct Index {
  @Consume('pageStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Text('Scroll to See More Content')
            .width('60%')
            .height(50)
            .margin({
              top: 20,
              left: 20,
              right: 20,
              bottom: 50
            })
          Button('Navigate to Form Page')
            .id('Form')
            .onClick(() => {
              this.pageStack.pushDestinationByName(NavigationPaths.FORM_PAGE, null)
            })
            .height(50)
            .margin({
              bottom: 50
            })
          Button('Navigate to Gesture Page')
            .id('Gesture')
            .onClick(() => {
              this.pageStack.pushDestinationByName(NavigationPaths.GESTURE_PAGE, null)
            })
            .height(50)
          Text('Scroll to See More Content')
            .height(50)
            .margin({
              bottom: 50
            })
          Text('End')
            .height(50)
            .margin({
              bottom: 50
            })
        }
      }
      .height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
  }
}