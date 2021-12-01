# Create Projects Using Angular Cli

Nov 2017

> Angular cli is a great tool for creating new applications following best practice style guide it creates testable, understandable maintainable file and folder organisation.

Instal Angular Cli globally. 

Documentation at https://cli.angular.io 

```
sudo npn install angular/cli -g
```

Next check Angular Cli has been installed correctly by using version flag.

```
ng -v
```

Next test out commands by using dry run flag.

New will create a new project 

With --dry-run flag set will log out to terminal and not create the application.

```
ng new appName --dry-run
```

Project setting are found in Project.json. Project.json will be interrogated by other commands like create controller. 

Following code will set app component prefix setting

```
ng new appName -prefix appName
```

Add Routing component

```
ng new appName --routing
```

Wrapped up commands - what I like to run when creating a new Angular app.

```
ng new appName --routing --prefix appPrefix --style css
````

Angular then creates a folder using appName provided.

Run npm install to ensure everything installed correctly.

```
npm install
```