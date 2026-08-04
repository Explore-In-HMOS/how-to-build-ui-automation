import { afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, PointerMatrix, UiDirection } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default function abilityTest() {
  let driver: Driver;
  let params: Record<string, string>;
  let screenshotPath: string | null;
  let delegator: abilityDelegatorRegistry.AbilityDelegator;

  beforeAll(async () => {
    delegator = abilityDelegatorRegistry.getAbilityDelegator();
    driver = Driver.create();

    const shellResult = await delegator.executeShellCommand('echo hello from shellCommand');
    hilog.info(0x0000, 'TestTag', `Shell Result: ${shellResult.stdResult}`);

    const context = delegator.getAppContext();
    screenshotPath = context.filesDir;

    const args = abilityDelegatorRegistry.getArguments();
    const bundleName = args.bundleName;

    const want: Want = {
      bundleName: bundleName,
      abilityName: 'EntryAbility'
    };

    await delegator.startAbility(want);
    await driver.waitForIdle(500, 3000);

    try {
      await driver.screenCap(`${screenshotPath}/home.png`)
    } catch (e) {
      hilog.error(0x0000, 'TestTag', e)
    }

    const ability: UIAbility = await delegator.getCurrentTopAbility();
    expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
  });

  beforeEach(async () => {
    await driver.waitForIdle(500, 1000)
  })

  describe('ActsAbilityTest', () => {
    it('navigationTest', Level.LEVEL3, async (done: Function) => {
      const formButton = await driver.findComponent(ON.id('Form'));
      await formButton.click();
      await driver.waitForIdle(4000, 4000);

      const window = await driver.findWindow({ active: true });

      await driver.waitForIdle(500, 4000);


      await driver.screenCap(`${screenshotPath}/form.png`);
      await driver.assertComponentExist(ON.hint('Name'));
      await driver.pressBack()
      done();
    });

    it('gestureTest', Level.LEVEL1, async (done: Function) => {
      const gestureButton = await driver.waitForComponent(ON.id('Gesture'), 1000);
      await gestureButton.click();
      await driver.delayMs(1000)

      await driver.screenCap(`${screenshotPath}/gesture_def.png`);

      const gestureText = await driver.findComponent(ON.id('GestureText'));
      await driver.waitForIdle(500, 4000);


      const bounds = await gestureText.getBounds();
      const width = bounds.right - bounds.left;

      const startX = Math.round(bounds.left) + 20;
      const farX = Math.round(bounds.right) - 20;
      const startY = Math.round((bounds.top + bounds.bottom) / 2);
      const endY = startY + 150;

      const pointerMatrix = PointerMatrix.create(2, 2);
      pointerMatrix.setPoint(0, 0, { x: startX, y: startY });
      pointerMatrix.setPoint(0, 1, { x: startX, y: endY });
      pointerMatrix.setPoint(1, 0, { x: farX, y: startY });
      pointerMatrix.setPoint(1, 1, { x: farX, y: endY });

      await driver.injectMultiPointerAction(pointerMatrix, 600);
      await driver.waitForIdle(500, 4000);


      await driver.screenCap(`${screenshotPath}/gesture_trig.png`);

      const doneComponent = await driver.findComponent(ON.text('Gesture Triggered'));
      await driver.pressBack()
      await driver.waitForIdle(500, 4000);

      expect(doneComponent != null).assertTrue();
      done();
    });

    it('focusTest', Level.LEVEL0, async (done: Function) => {
      let formButton = await driver.waitForComponent(ON.id('Form'), 1000)

      await formButton.click()
      await driver.delayMs(1000)
      let nameField = await driver.findComponent(ON.hint('Name'))
      let namePoint = await nameField.getBoundsCenter()
      await nameField.click()
      await driver.inputText(namePoint, 'John')
      await driver.delayMs(600)
      await driver.screenCap(`${screenshotPath}/focused.png`)
      let isFocused = await nameField.isFocused()
      let hasName = await driver.findComponent(ON.originalText('John'))

      expect(isFocused && hasName != null).assertTrue()
      await driver.pressBack()
      done()
    })

    it('scrollTest', Level.LEVEL1, async (done: Function) => {
      await driver.waitForComponent(ON.id('Form'), 1000)
      await driver.fling(UiDirection.DOWN, 20000);
      await driver.waitForIdle(500, 4000);


      const end = await driver.findComponent(ON.text('End'));
      expect(end != null).assertTrue();
      done();
    });
  });
}