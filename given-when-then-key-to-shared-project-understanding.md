# Given When Then - Key to Shared Project Understanding

> Oct 2017

Specification by example has been one of biggest game changers in development, improving collaboration between business, consumers, testers, developers and more.

Im a big fan and champion of using Given When Then/Gherkin syntax - it enables a team or whole business to communicate complex ideas effectively in a test first manner - it simply describes a scenario (what a piece of software should do or for that matter a process), ideal for storyboarding, engaging with business stakeholders, developers and testers.

This approach is interchangeably called Behaviour Driven Development, Specification by Example or Acceptance Test Driven Development. I'd recommend you check out Specification by Example by Gojko Adzic. 

As with all good software it solves a problem, and that starts with an idea, but that idea needs to be comunicated and thats where Given When Then fits in moreover its provides acceptance criteria and test scenarios - importantly before a piece of code is written.

So we have been able to discuss across teams what the software will do, during discussion we have created business readable documentation describing what the system will do, during discussion and documentation we have shared understanding and refined scenarios, created acceptance criteria, created test success criteria and created test cases.  

If you write tests you will know about AAA Arrange Act Assert 

Arrange is the test setup, Act is running the code and Asset is evaluating the results.

Given = Arrange 
When = Act
Then = Assert  

For example take a login feature:

Given not logged in 
When accessing restricted page
Then presented with login page 
And page is secure 

Given logged in 
When accessing restricted page
Then page displayed 
And restricted page is secure 

Given not logged in 
And on homepage 
When click Sign In 
Then presented with login page 
And page is secure 

Given user in datastore
and not logged in 
And on login page
When enters username 
And enters password incorrect 
Then password error displayed 
And page is secure 

Given user in datastore
and user not logged in 
And on login page
When enters username 
And enters password 
Then logged in 
And dashboard page displayed  
And auth cookie secure 
And login logged 
and name displayed in profile link  

As an aside you can see there are quite a few scenarios dealing with login - most you could mark as common sense but different people have diferent definition of done (see definition of done post for ensuring a team meets same quality criteria).

Now we have the scenarios the team understards whats being built, we can now parse these scenarios and turn then into tests - pretty cool!