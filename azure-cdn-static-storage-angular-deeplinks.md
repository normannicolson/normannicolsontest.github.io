# Using Azure Cdn to Enable Static Storage Angular Deeplinks 

Sep 2024 

> Using Azure Cdn rules engine to enable angular deeplinks hosted on static storage.  

Azure Storage is a great option of hosting a static Single Page Application.

Use Azure Content Delivery Network to improve website load times serving context geographically closer.

As CDNs are distributed they provide built-in redundancy.

As Angular or other Single page applications hosted on Azure Storage are completely client side they cant redirect server side so we are left with page not found as no file exits matching route name.

## Static website setting 

Set Index document and Error document paths to ```index.html``` Angular application.

Alternatively 

## Routes  

```
If URL file extension

Operator=Not greater than
Extension=0
Case transform=No transform

Then URL rewrite

Source pattern=/
Destination=/index.html
Preserve unmatched path=No
```

```
And then Modify response header

Action=Append
HTTP header name=x-nlist-cdn-name
HTTP header value=routes
```

## Files 

```
If URL file extension
Operator=Greater than
Extension=1
Case transform=No transform

Then Modify response header

Action=Append
HTTP header name=x-nlist-cdn-name
HTTP header value=files
```