# Run Projects Using Angular Cli

Nov 2017

> Angular cli commands for testing, launching and building artifacts.

Compile into dist folder and launch web browser, any edits will cause recompilation.

```
ng serve -o
```

Publish app into dist folder, then dist folder can be packaged.

```
ng build
```

Under the hood Angular Cli invoking node can use run

```
npm run ng build
```