# Mvc Editor Templates

Sep 2017

> How to use html.editorfor to customise presentation, reduce code duplication and ensure constancy.

Create folder /Views/Shared/EditorTemplates

Create file String.cshtml 

```
@model string

<div class="form-group">
    @Html.LabelFor(model => model)
    @Html.TextBoxFor(model => model, new { @class = "form-control" })
    @Html.ValidationMessageFor(model => model)
</div>
```

Use

```
@model Company.Product.Web.Models.User

@Html.EditorFor(model => model.Id)

@Html.EditorFor(model => model.Name)
```