---
name: Onboard new developer
about: Checklist for onboarding a new team developer to covidtests.usa.gov
title: "[Onboard] <email>"
---

Welcome! And thank you!

### Tasks for existing team member

- [ ] Review the rest of the checklist below before starting to work through it. Any step that does not seem relevant or necessary for the kind of work that the person onboarding will be doing should have a `-` in the checkbox and `~` around the line so it's clear that we will not be granting that particular kind of access for this person.
- [ ] Add team member to [TTS Slack](https://handbook.18f.gov/slack/#tts-staff)
  - #test-website (main)
  - #covidtest-app (shared with USDS)
  - #tts-covidtest-devops (platform & devops)
  - #tts-covidtest-rails (app development)
  - #tts-covidtest-rails-alerts (development-related alerts, like Github)
  - #tts-covidtest-production-alerts (prod-related alerts, like New Relic)
  - #tts-covidtest-situation (active incident resolution)
- [ ] Add team member to [Google Drive](https://drive.google.com/drive/folders/1u2VvxA9CqFXWSdqLVd21wGM7J-MdMn2b)
- [ ] Add team member to Service Now
- [ ] Add team member to [New Relic](https://account.newrelic.com/accounts/3389907/users)
- [ ] Grant team member Space Developer access to all relevant CF spaces via `bin/cf-onboard` (TK intended usage)

### Tasks for new team member
- [ ] Accept invite and confirm access to all CF spaces
- [ ] Accept invite to New Relic (need to be on VPN) and [confirm access to dashboards](https://one.newrelic.com/launcher/nr1-core.launcher?platform[filters]=Iihkb21haW4gPSAnQVBNJyBBTkQgdHlwZSA9ICdBUFBMSUNBVElPTicpIg==&platform[accountId]=3389907&platform[timeRange][duration]=259200000&platform[$isFallbackTimeRange]=true&pane=eyJuZXJkbGV0SWQiOiJucjEtY29yZS5ob21lIiwiZmF2b3JpdGVzIjp7InNlbGVjdGVkIjp0cnVlLCJ2aXNpYmxlIjp0cnVlfSwibGFzdFZpZXdlZCI6eyJzZWxlY3RlZCI6ZmFsc2UsInZpc2libGUiOnRydWV9fQ==&sidebars[0]=eyJuZXJkbGV0SWQiOiJucjEtY29yZS5jYXRlZ29yaWVzIiwicm9vdE5lcmRsZXRJZCI6Im5yMS1jb3JlLmhvbWUiLCJmYXZvcml0ZXMiOnsic2VsZWN0ZWQiOnRydWUsInZpc2libGUiOnRydWV9LCJsYXN0Vmlld2VkIjp7InNlbGVjdGVkIjpmYWxzZSwidmlzaWJsZSI6dHJ1ZX19&state=35d5c03f-c2c9-169c-b2ac-bfab24ef789e)
- [ ] Review [Service Now documentation](https://docs.google.com/document/d/1Ayrv0tZOv6lF1iDOdofni4gZOSTPA5t9KMf6VcxBFcw/edit#heading=h.sp4on5mexvju)
    - [ ] Confirm you have set your SMS notification correctly
- [ ] [If needed] Confirm log access to each of the foundations
    - [ ] Install CF CLI 
    - [ ] Configure `cf targets` plugin
    - [ ] Set up target for each space on each foundation (TK script)
- [ ] Familiarize yourself with our [incident response checklist](https://github.com/usagov/test-at-home/wiki/Incident-Response-Checklist)
- [ ] Familiarize yourself with our application in [staging](https://staging-covidtest.usa.gov)
