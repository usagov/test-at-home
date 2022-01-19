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
- [ ] [If cloud.gov access needed] Invite team member to all CF foundations
    - [ ] [fr.wb.cloud.gov](https://account.fr.wb.cloud.gov/invite)
    - [ ] [fr.wc.cloud.gov](https://account.fr.wc.cloud.gov/invite)
    - [ ] [fr.ea.cloud.gov](https://account.fr.ea.cloud.gov/invite)
    - [ ] [fr.eb.cloud.gov](https://account.fr.eb.cloud.gov/invite)
- [ ] [If cloud.gov access needed] After they've accepted all CF invites, grant team member Space Developer access to all relevant CF spaces via `bin/ops/cf-onboard`.
    ```
    bin/ops/cf-onboard <EMAIL> SpaceDeveloper prod,staging tah-ea,tah-eb,tah-wb,tah-wc
    ```
    This requires spaces to be configured by the names above. To set these, [install `cf targets`](https://github.com/guidowb/cf-targets-plugin#installation) and configure with:
    ```
    cf api api.fr.wb.cloud.gov; cf login --sso; \
        cf t -o gsa-tts-test-kits; \
        cf save-target -f tah-wb

    cf api api.fr.wc.cloud.gov; cf login --sso; \
        cf t -o gsa-tts-test-kits; \
        cf save-target -f tah-wc

    cf api api.fr.ea.cloud.gov; cf login --sso; \
        cf t -o gsa-tts-test-kits; \
        cf save-target -f tah-ea

    cf api api.fr.eb.cloud.gov; cf login --sso; \
        cf t -o gsa-tts-test-kits; \
        cf save-target -f tah-eb

    # Verify:
    cf targets
    ```

### Tasks for new team member
- [ ] Accept invite to New Relic (need to be on VPN) and [confirm access to dashboards](https://one.newrelic.com/launcher/nr1-core.launcher?platform[filters]=Iihkb21haW4gPSAnQVBNJyBBTkQgdHlwZSA9ICdBUFBMSUNBVElPTicpIg==&platform[accountId]=3389907&platform[timeRange][duration]=259200000&platform[$isFallbackTimeRange]=true&pane=eyJuZXJkbGV0SWQiOiJucjEtY29yZS5ob21lIiwiZmF2b3JpdGVzIjp7InNlbGVjdGVkIjp0cnVlLCJ2aXNpYmxlIjp0cnVlfSwibGFzdFZpZXdlZCI6eyJzZWxlY3RlZCI6ZmFsc2UsInZpc2libGUiOnRydWV9fQ==&sidebars[0]=eyJuZXJkbGV0SWQiOiJucjEtY29yZS5jYXRlZ29yaWVzIiwicm9vdE5lcmRsZXRJZCI6Im5yMS1jb3JlLmhvbWUiLCJmYXZvcml0ZXMiOnsic2VsZWN0ZWQiOnRydWUsInZpc2libGUiOnRydWV9LCJsYXN0Vmlld2VkIjp7InNlbGVjdGVkIjpmYWxzZSwidmlzaWJsZSI6dHJ1ZX19&state=35d5c03f-c2c9-169c-b2ac-bfab24ef789e)
- [ ] Review [Service Now documentation](https://docs.google.com/document/d/1Ayrv0tZOv6lF1iDOdofni4gZOSTPA5t9KMf6VcxBFcw/edit#heading=h.sp4on5mexvju)
    - [ ] Confirm you have set your SMS notification correctly
- [ ] [If cloud.gov access needed] Accept invite to each CF foundation via email and configure CF targets
    **Note**: OTP code doesn't seem to work for Secure Auth; use email. Recommend being on VPN for less flakiness. Initial invites expire after 24 hours, so ask for new one if expired.
    - [ ] Accept wb foundation email invite
    - [ ] Accept wc foundation email invite
    - [ ] Accept ea foundation email invite
    - [ ] Accept eb foundation email invite
    - [ ] Let admin know you have accepted invites so they can grant you access to spaces
    - [ ] After admin grants you space access, configure local CF targets for easy switching:
        ```
        # Install [cf-targets plugin](https://github.com/guidowb/cf-targets-plugin)
        cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org/
        cf install-plugin Targets -r CF-Community

        # Set targets
        cf api api.fr.wb.cloud.gov; cf login --sso; \
            cf t -o gsa-tts-test-kits; \
            cf save-target -f tah-wb

        cf api api.fr.wc.cloud.gov; cf login --sso; \
            cf t -o gsa-tts-test-kits; \
            cf save-target -f tah-wc

        cf api api.fr.ea.cloud.gov; cf login --sso; \
            cf t -o gsa-tts-test-kits; \
            cf save-target -f tah-ea

        cf api api.fr.eb.cloud.gov; cf login --sso; \
            cf t -o gsa-tts-test-kits; \
            cf save-target -f tah-eb
        ```
- [ ] Familiarize yourself with our [incident response checklist](https://github.com/usagov/test-at-home/wiki/Incident-Response-Checklist)
- [ ] Familiarize yourself with our application in [staging](https://staging-covidtest.usa.gov)
- [ ] Read the [Run Book](https://github.com/usagov/test-at-home/tree/main/doc/run-book.md)
