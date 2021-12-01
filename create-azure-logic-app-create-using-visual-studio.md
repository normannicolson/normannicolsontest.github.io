# Create Azure Logic App Using Visual Studio

Feb 2018

> Walkthrough creating an azure logic app using visual studio.

First ensure Azure Logic App tools are installed, we do this by clicking Tools menu and then clicking Extensions and Updates this lists extensions installed.

We use the search box and enter our search term "Logic".

On search a new view appears with search results, we now download Azure Logic Apps Tools for Visual Studio.

Download dialog appears and will complete.

After a Visual Studio reboot - needed to install extension or updates -  we can now create an azure logic apps.

To create an Azure Logic app from Visual Studio, we add a new project to solution then Add New Project window appears, we filter by by language of then on Cloud node this will list Azure Resource Group.

On selecting Azure Resource Group as our project type a second screen appears with choice of visual studio templates. We scroll until we find "Logic App" and select.

On selecting Azure Resource Group our logic app project is created, we can now start coding by editing LogicApp.json file using Workflow Definition Language schema for Azure Logic App

https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-workflow-definition-language 

On opening LogicApp.json we see the default logic app definition. We can now start editing.