# Custom Mvc Model Binder

Oct 2017

> Sometimes the request data names do not match the model data. model binders are responsible for mapping requests to models providing a clean separation of concerns keeping controllers clean and model representative.

```
using System.Web.Mvc;
using Nlist.Web.Areas.Admin.Binders;
using Nlist.Web.Areas.Admin.Models;

namespace Nlist.Web.Startups
{
    public class ModelBinderConfig
    {
        public static void RegisterModelBinders(ModelBinderDictionary routes)
        {
            ModelBinders.Binders.Add(typeof(Asset), new AssetModelBinder());
        }
    }
}
```

```
using System;
using System.Web.Mvc;
using Nlist.Web.Areas.Admin.Models;

namespace Nlist.Web.Areas.Admin.Binders
{
    public class AssetModelBinder : DefaultModelBinder, IModelBinder 
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            var model = (Asset)base.BindModel(controllerContext, bindingContext);

            model.Name = model.Name ?? String.Empty;

            return model;
        }
    }
}
````