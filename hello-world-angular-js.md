# Hello World Angular Js

Oct 2017

> Most basic of angular js example.

```
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="viewport" content="width=device-width" />
    <title>Hello World - Angular Js Examples</title>

    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/angular.js"></script>

    <script type="text/javascript">
        (function () {
            var app = angular.module("app",[]);

            var helloWorldController = function($scope) {
                $scope.title = "Hello World Demo App";
                $scope.message = "This is the most basic of AngularJs apps";
            };
            
            app.controller("helloWorldController", helloWorldController);
        }());
    </script>
</head>
<body ng-app="app">
    <div class="container">
        <div ng-include="'/_Navigation.html'"></div>

        <div ng-controller="helloWorldController">
            <h1>{{title}}</h1>

            <div class="row">
                <div class="col-sm-8">
                    <p>{{message}}</p>
                </div>
                <div class="col-sm-4">
                    <ul>
                        <li>This app demos a hello world type AngularJs Application. Displays a message on the page.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
```