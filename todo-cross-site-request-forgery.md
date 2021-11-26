# Cross Site Request Forgery

> Asp.net mvc demo of threat and how to mitigate using anti-forgery tokens.

Cross site request forgery is an type of attack, that allows an authenticated user to perform an operation without there knowledge.

Common scenario is a vulnerable banking website they don't validate requests so are vulnerable to this attack.

They have a page for money transfer where you can enter destination account details and amount then after click confirm.

On confirm the money is transferred.

On the confirm page there is the vulnerability. 

So a link could be sent to 

And attacker has reference to    

Take vulnerable  back 

Is a very easy to perform attack 

An attacker will 

Require two websites a vulnerable website and an attackers website.

## Example of vulnerable form

```
<form action="/controller/delete" method="post">
<h1>You Are a Winner!</h1>
<input id="Id" name="Id" type="hidden" value="123" />                
<button type="submit" class="button">Submit</button>
</form>
```

Attacker exploitation of weakness 

```
<form action="https://example.com/controller/delete" method="post">
<h1>You Are a Winner!</h1>
<input id="Id" name="Id" type="hidden" value="123" />                
<button type="submit" class="button">Win</button>
</form>
```

Mvc Form with AntiForgeryToken

```
using (Html.BeginForm("Action", FormMethod.Post))
{
    @Html.AntiForgeryToken()
    @Html.EditorFor(m => m.Id)
    <button type="submit" class="button">Submit</button>
}
```

Mvc Controller

```
[HttpPost]
[ValidateAntiForgeryToken]
public ActionResult Index(Model model)
{
    return this.View(model);
}
```