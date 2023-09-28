# Azure Dev Ops Yml Build steps for B2c Templates

Dec 2021

> Yaml Azure DevOps B2c Template build pipleline

Build B2c Templates into build artefacts.

The templates directory comtains html and css templates which are used by the b2c policies.

Assets referred to within the template need to point to absolute urls as b2c is hosted on a different domain from the templates.

All assets (css, html, images) are copied into the dist folder when built ```npm run build```

The templates are styled using scss, this is compiled into a single css file using npm.

Placeholders for the content hosting domain and the domain of auth are normally added at release time. To view the templates locally you can run ```npm run build-local``` this will produce populated templates in the dist folder. 

src/templates folder files
```
src
package.json
```

package.json
```
{
  "name": "templates",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "npm run build-css && npm run copy-templates && npm run copy-images && npm run copy-scripts",
    "build-css": "sass ./src/styles/entry-point.scss  ./dist/main.css",
    "copy-templates": "copy src\\*.html dist\\",
    "copy-images": "copy src\\images\\*.png dist\\",
    "copy-scripts": "copy src\\*.js dist\\",
    "build-local": "npm run build && npm run replacePlaceholders",
    "replacePlaceholders": "replace-in-files --string='__TemplateAuthDomain__' --replacement='' dist/*.html && replace-in-files --string='__TemplateContentDomain__/' --replacement='' dist/*.html"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "replace-in-files-cli": "^2.0.0",
    "sass": "^1.43.4"
  }
}
```


```
- script: |
    cd src/templates
    npm install
  displayName: 'Templates - npm install'

- script: |
    cd src/templates
    npm run build
  displayName: 'Templates - npm run build'
  
- task: CopyFiles@2
  displayName: "Copy Templates"
  inputs:
    SourceFolder: 'src/templates/dist'
    Contents: '**'
    TargetFolder: 'publish_output/templates'
```