# Definition of Done

Sep 2017

> A checklist for defining done.

Everything starts with a story – a benefit of story it illustrates user benefit easy for business and development to understand.

Stories have many given when then scenarios – helps with understanding, acceptance criteria, estimations and test driven development.

Code developed should adhere to SOLID principles https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)
Single responsibility principle - a class should have only a single responsibility (i.e. changes to only one part of the software's specification should be able to affect the specification of the class)
Open/closed principle - “software entities … should be open for extension, but closed for modification.”
Liskov substitution principle - “objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.” See also design by contract.
Interface segregation principle - “many client-specific interfaces are better than one general-purpose interface.”
Dependency inversion principle - one should “depend upon abstractions, [not] concretions.”

Code should be built using test driven development.

All code should be committed and peer reviewed.

Code to follow Company Stylecop coding style.

Project names should be singular but namespaces pluralised.

A test project should only test one project the suffix “.Test” should be used for default CI configuration.

Integration tests that interact from web/api to datastore for simple sandbox should follow separate naming convention like “.Test.Integration” so CI server can distinguish.

Automation is applied to sandbox testing environment “Test.Automation”.

All datastore changes are scripted and have upgrader for automated continues deployment.

Data store has minimum access permissions for requirements.

Certificates are documented.

JavaScript & Css are developed in many files like .cs files.

JavaScript & Css is minified and bundled on build.

Linting is applied to Css less Js etc.

All code should go via gated mages that apply stylecop rules.

All packages should be issued by Microsoft where possible any other been reviewed.

Code to be tested for security and developed with security in mind.

Threat model should be upto date.