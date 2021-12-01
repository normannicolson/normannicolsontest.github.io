# Project Naming Convention

Sep 2017

> Scalable convention based project naming convention.

Sadly (for my sanity) I prefer convention over configuration, I’m no different with project naming. Useful naming can convey intent, understanding and code decoupling.

We see convention across Microsoft and other packages.

Since I right from left to right I find it easier to specialise from left to right like the Japanese date format specialising from year to month to day.

Company.Product.Component.SubComponent and on

For example take an N tier notification web application containing Data, Business & Presentation layers

Inc.Notification.Data.Sql a sql data layer

Inc.Notification.Data.DocumentDb a document db layer

Inc.Notification.Business.Model a domain model core or business layer

Inc.Notification.Business.Workflow.Approval an azure logic logic app

Inc.Notification.Web.Api a web api

Inc.Notification.Web a website

And each could have a test project with a singular .Test suffix 

Inc.Notification.Web.Test 