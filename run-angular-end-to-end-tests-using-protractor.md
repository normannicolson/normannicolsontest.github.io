# Run Angular End to End Tests using Protractor

Jun 2018

> How to run end to end tests using angular cli.

When creating an Angular app using Anguar Cli Protractor is configured and ready to run.

Protractor is built on top of WebDriverJS, WebDriverJS is a javascript library for browser automation testing.

https://github.com/SeleniumHQ/selenium/wiki/WebDriverJs 

Run end to end using the e2e command.

```
ng e2e
```

Creating page models are easy.

```
import { browser, by, element } from 'protractor';

export class HomePage {
  navigateTo() {
    return browser.get('/');
  }

  header() {
    return element(by.css('h1')).getText();
  }
}
```

Tests are written in Jasmine so read nice.

```
import { HomePage } from './homePage.po';

describe('Home page', () => {
  let page: HomePage;

  beforeEach(() => {
    page = new HomePage();
  });

  it('should display header', () => {
    page.navigateTo();
    expect(page.header()).toEqual('Welcome');
  });
});
```

Jasmine produces human readable output ideal for documenting functionality.  

```
Home page
    ✓ should display header
```