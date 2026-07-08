# Free Migration Checklist

Use this checklist for production operations outside the public repository.

- Make Lumy free in App Store Connect and Google Play.
- Remove any store-managed products.
- Decide how to handle any existing store-managed access.
- Shut down the old monetization provider project and hooks after the last deployed app version no longer depends on them.
- Update app-store descriptions, privacy labels, terms/privacy links, and support copy.
- Communicate the free and open-source change to users.
- Confirm production no longer depends on legacy monetization database state.
- Rename the private deployment repository to `lumy-deployments`.
- Create the fresh public `elyon-labs/lumy` repository from this cleaned tree without private history.
