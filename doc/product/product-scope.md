# Goals & Objectives
A web-based, mobile-responsive solution for the public to submit a pre-order request for 1 set of four COVID-19 tests to be sent directly to their home through the USPS infrastructure. This solution is intended to be a back-up for the USPS web store, if it cannot stand peak traffic.

The launch date for this solution is January 17, 2022.
Key Stakeholders
- USPS: Is responsible for coordinating and fulfilling at-home test orders requested using their existing mail delivery infrastructure. 
- USDS is supporting HHS, DOD, and USPS in sourcing at-home tests and ensuring the testing request service is successful both in technology and in actual service completion.
- TTS: Developing a ‘back-up’ application to accept orders mitigate risk if USPS online store cannot accommodate traffic.
- White House Office of Digital Strategy: Designing and maintaining landing page directing the public to the test request form either within the USPS store or the back-up solution being developed by TTS.

# What this system will do

Reside at USAgov URL as we are using USAgov authorities/SORN. 
- USAgov subdomain
    - 1 staging
    - 1 prod

User is sent to application from covidtests.gov landing page call to action
- 100M requests/day
- Peak traffic - TBD

Languages supported:
- English
- Spanish
- Simplified Chinese

Fields to be collected on each order
- Name
- Address (include APO/FPO)
- phone (may be optional, USPS is assessing)
- email

Address validation of each order
- User will have the option to accept what they entered in the field vs. validated (suggested) addresses.
- This validation must happen whether USPS address validator is available or not.

Each order must be retained until it is delivered to the USPS fulfillment system
- Design as if USPS system can be down for days
- TBD on requirements of submission to USPS. May be CSV export uploaded to FTP site and/or bulk or individual send via API. Data requirements not yet known

Collect analytics on how long it takes to complete the task, dropoff at each step

Limited fraud concerns in scope:
- USPS may need name for post-processing, but that is being confirmed
- A 508/accessible countermeasure to bots (captcha/recaptcha)
- IP filtering along the lines of what we think of normal DDOS considerations
# System sequence diagram

<img src="https://github.com/usagov/test-at-home/blob/main/doc/product/assets/system-sequence-diagram.png"
     alt="Message sequence chart for TTS system"
     style="float: left; margin-right: 10px;" />
     
# What this system will not do
- Verify identity information
- Provide authorization or eligibility
- Allow users to view or track status of requests
- Provide email confirmation on order submission
- There will be no name validation
- This will not be a long-term solution, used only in high traffic (beyond USPS capacity) situations. Upon leveling of traffic, USPS will be used as primary solution.

## USPS is responsible for:
- Dedupe across orders for multiple orders sent to the same address. The fulfillment system will enforce 1 test kit per household constraint.
- Order confirmation outside of our application last confirmation page (e.g. email confirmation)
- Fulfillment tracking
    - We will not store orders after delivery to USPS system, so no need for USPS to send any package tracking info back to us.
- Responsible for malicious input validation of data they ingest.
    - We will not validate name 
 
# User considerations
## Product Functionality Stories
- **I am able to provide explicit consent** to share my data with USPS.
    - Plain/accessible language will be presented on the submission screen. The user’s action of submitting the form will indicate their consent to sharing.
- **I can request a set of tests to be sent to other**s who may not be able to request for themselves. (e.g. a grandparent)
- **I am able to translate this website into Spanish or Simplified Chinese,** so that if I don’t read fluent English I can still use this site.
- **As someone requesting from a military base**, overseas or inside the United States, I am able to input specific military base address information. 
    - Note: These users may also be using the same IP address which could present additional barriers to fraud control using IP.
- **I am able to seamlessly access this form with assistive technology** if I am someone who uses a screen reader or or magnification software.
- **I am able to easily fill out and submit the form on my mobile device** in case I don’t have access to a desktop computer.
- **I am able to override an address validation** if it is incorrect.
- ~~**I am able to receive an order number (outside of the USPS tracking)**~~
- **I am able to view a confirmation page showing my request has been received** 

## Content-Focused Stories
- **I know why and when I should request a set of tests** so that I am prepared to keep myself and the community safe most effectively.
- **I know when I should use the tests I am sent** to ensure I am keeping myself and my community safe most effectively. (e.g. when you have symptoms or be exposed)
- **I know who I can call for support navigating the website and filling out the form,** if I have trouble with technology
- **I know what types of accessible services** are available if I call for support filling out the form.
- **I understand how my data is being kept safe** and what my rights are around data sharing (Privacy Act disclaimer).
- **I understand what I can do if my kit arrives damaged or unusable** so that I feel satisfied with my ordering experience.

# Support of Application
- Expect war room day of launch
- 24/7 rotations for monitoring

# Metrics
## Monitoring to ensure site is working (Early Days)
- Peak Traffic - Site doesn’t break
- Where do they fall off?



