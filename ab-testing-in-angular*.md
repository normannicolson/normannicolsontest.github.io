# A/B Testing in Angular *

Aug 2020

> AB testing is the act of testing a hypothesis (a hypothesis in the scenario is a proposed explanation about a piece of functionality, product, flow or UI etc based on limited data). AB testing provides empirical evidence for informed decision making comparing functionality A versus functionality B even product A versus product B.

AB testing enables experimentation and measurement for example a checkout experience, imagine we are online coffee shop, we roast and sell our beens online:

- Hypothesis more users will purchase our beens with a guest payment experience.  
- Functionality A requires signup before purchase.
- Functionality B allows guest purchase capability and signup after purchase.

Users are spit into alternating groups A or B

First User get functionality A
Second User gets functionality B
Third User gets functionality A
Fourth User gets functionality B and so on

## How we Measure

Depending on what we are measuring our experiment can start as soon as someone visits our site. In our example we are comparing checkout experiences we start on checkout button click.

When we click checkout our session is routed to functionality A normally what we already use (sign in or sign up) or functionality B (sign in or guest checkout).

We measure events across both functionalities:

Guest checkout will allow users users to signup when email and delivery information is captured without needing to capture any additional information.

For functionality A (sign in or sign up)

- Test start 
- Sign in
- Sign up
- Existing user order
- New user order

For functionality B (sign in or guest checkout)

- Test start 
- Sign in
- Guest order
- Existing user order
- New user order
- Sign up

New user order is determined if user signed up during purchase.

The Measurement

500 

## Compare 
