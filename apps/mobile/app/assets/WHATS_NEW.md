## 1.26.2

**Fixes:**
- Fixes an issue where duplicate transactions could remain in Lumy's reports after syncing.

## 1.26.1

**Fixes:**
- Fixes an issue where some long-term transactions could be omitted from Lumy's reports.

## 1.26.0

Lumy is now free and open source! You can read more [here](https://lumyforynab.app/open-source).

If you are a subscriber, you will no longer be charged and will continue to have access to all of Lumy's features. If you would like to support Lumy, you can make a donation [here](https://www.buymeacoffee.com/btrautmann).

## 1.25.0

**Features:**
- You can now change the email address associated with your Lumy account. Just navigate to Settings -> Account.

**Fixes:**
- Fixes an issue that would cause intermittent duplication of split transactions created from a scheduled transaction.

## 1.24.18

**Fixes:**
- Fixes an issue where the app may request write access even after being granted it.

## 1.24.17

**Fixes:**
- Fixes an issue where transaction templates would not reflect the settings they were created with (fire immediately, flag, etc.).

## 1.24.11

**Fixes:**
- Fixes an issue where the circular "avatar" shown for category and transaction rows would display an error symbol when the category or transaction payee name began with an emoji.
- Fixes an issue that prevented users from accessing the feedback board to provide feedback or report bugs.

**Improvements:**
- Increases the reliability of creating spend trackers, category views, frugal months, and transaction templates by ensuring that if an error occurs during creation, the entire procedure is aborted, rather than half-baked data being saved.

## 1.24.10

**Fixes:**
- Fixes an issue with currency input for some currencies in the transaction template screens. Previously, currency input was constrained to too small an input length, but that constraint has been lifted and large amounts are better supported.

**Changed:**
- As part of the above fix, all currency input across the app is now the same. This applies primarily to frugal months and transaction templates, but will apply to any future inputs as well.
- Sub-transaction amount input for transaction templates is no longer done via a modal. Instead, input occurs directly on the transaction template screen for more rapid entry.

## 1.24.7

**New:**
- Introduces device syncing capabilities, allowing you to automatically back up your Lumy data and access it on other devices by linking your email address. Existing users will be prompted to link an email address but maintain the option to continue as a guest. Those who choose the "guest" option can continue using Lumy without linking an email, but are at risk of data loss in the event of a logout or uninstall (the same as before!). Now, users with a mobile device and tablet (or multiple mobile devices!) can easily use the same Lumy data across their devices.

**Important Notes (please read!):**
- This was a major architectural overhaul as this type of functionality wasn't planned from the beginning. Most obstacles were easily overcome, but one that was difficult was migrating the data itself. This resulted in a one-time need for existing users to manually back up their data before it being accessible. You should be prompted to do so as soon as you choose an authentication option (link an email or remain a guest). Once done, you never have to it again. If you aren't prompted, head over to the Settings tab and scroll down to "Backup Lumy data".
- Regarding _what_ data is synced: ONLY Lumy data is ever synced across devices. This means your spend trackers, category views, frugal months and transaction templates are synced, while all of your financial data fetched via YNAB remains on YNAB-servers _only_. This is both done to reduce redundancy (i.e. having copies of YNAB data and no single-source-of-truth), but also for your peace of mind.

**Changed:**
- A bit of UI freshening, as it's hard to do a major rewrite without sprucing some things up along the way.

## 1.23.8

**New:**
- Updates the calculation for spent amount in the Targets Health report such that categories with durations longer than the currently selected date range will show the average spent for the entire duration of the target, not the date range. This is helpful in cases where you're viewing a shorter date range than the target duration and within that date range you paid the full amount of that target. Previously, that would've skewed your target health to look unhealthy--now, (assuming you haven't actually overspent your target), the target will correctly be healthy. Categories with monthly targets or targets less than the currently selected date range will continue to show average monthly spending across the entire date range.

## 1.23.7

**Fixes:**
- Fixes an issue where the Target Health Report was not updating when changing budgets.
- The Choose Period bottom sheet now closes after a period is selected. This better conforms to how other bottom sheets behave in the app.

## 1.23.6

**New:**

- Adds the ability to quickly see over-spending for categories and category groups in the Budget Burndown. Previously, over-spending was not shown and a $0 remaining balance was shown instead.

**Fixes:**
- Ensures that changes to category group names are reflected immediately. This was previously not happening due to a YNAB API limitation, but we added a workaround to ensure a better user experience.
- Ensures the ordering of category groups and their categories matches what you see in YNAB. Previously, ordering in Lumy only matched that of YNAB until you changed the order in YNAB. This is because the YNAB API does not communicate ordering changes in delta requests, which Lumy makes use of. Now, categories are pulled fresh and so the ordering can be respected.
- Fixes an issue where transactions created via templates were always inflows, even if they were configured as outflows.

## 1.23.2

Introduces transaction templates, which allow you to configure certain properties of common transactions and then tap a button to instantly create that transaction or fill out the remaining properties and then create the transaction. Please note that this is the first feature that _writes_ to your budget, and as such, will require you to provide write access before creating any transactions.

**Note about the beta**: Right now, for ease, templates are written to your settings. Logging out will delete them. Additionally, they may be deleted if breaking changes are introduced. We will do our best to avoid that though!

**Some common use cases**:

- _You purchase the same thing at a vending machine at work every so often:_ You could create a "Candy bar" template that has the payee "Vending Machine", an amount of $1.99, a category of "Snacks", and an account "My Checking". Maybe even throw in a memo of "My favorite mid-day treat". If you set up the template to "fire immediately", you can simply tap the template from your Budget Tab to instantly create that transaction whenever you want.
- _You tend to split a meal with friends at lunch:_ You could create a template that has a split transaction configured, and only enter the amounts once you know them, categorizing your amount as "Dining Out" but the remainder as "Money I'm Owed".

There are a lot of other use cases I'm sure, and maybe ones that we don't yet support. We'd love your feedback on what we can add/change about this feature.

## 1.22.7

- Allows for quicker modification of spend tracker names by pre-populating the name field with the existing name during modification. Previously the existing name was shown as a "hint" that could not be modified.

## 1.22.3

- By popular request (mostly in Discord, which you should join to take part in these conversations!), all types of transactions are now shown on the Payees tab of the Recurring Transactions screen. Previously, this screen aimed to be more of a "subscriptions" tracker, but since Lumy can't really know which of your transactions are "subscriptions", this led to a confusing experience where some transactions (such as transfers or inflows) were not shown. Now, everything is shown. Let us know if you dislike this change and we can consider making this setting configurable! 

## 1.22.2

- Fixes the Send Feedback form so you can actually send feedback via the app now...We were wondering why it'd gotten so quiet!

## 1.22.0

**Additions**

- Design updates across the application to simplify the design system and make it simpler to introduce new UI
- Added the ability to sort the Recurring Transaction (by Payee) report alphabetically and by amount in both ascending and descending fashion.
- Report periods are now "trailing", meaning if you select, for example, the Latest 3 Months Period in December, you will initially see reporting for October, November, and December. However, on Jan 1, you will start seeing reporting for November, December, and January without needing to re-select Latest 3 Months like you would've had to do prior to this change.
- The Frugal Month Section on the Budget Tab now highlights the Left to Spend amount instead of the status. The status can be seen by tapping the Frugal Month tile. Additionally, when a Frugal Month is active, it shows above the Spent this Month section.

**Fixes**

- Fixed an issue with the Advanced Spend Tracker Query Builder for Advanced AST users where having enough conditions would make it impossible to add more.

**Removals**

- I have decided to remove the (barely in beta) Goals feature. It may be revisited at a later time, but the amount of work it would take to maintain the feature as initially scoped would be way too high for a one-man team. For now, I'd like to focus most of my efforts on functionality I feel is more at the heart of what Lumy aims to do, such as more advanced reporting functionality.
- Additionally, the "Highlights Section" has been removed from the Budget Tab for a couple reasons. The Left to Spend metric was redundant with the Burndown section title and now that the Frugal Month section shows the current Left to Spend amount, it was no longer needed. The Days of Buffer metric was confusing more folks than it was helping as it didn't align with the DOB metric shown on the Reports tab due to them using potentially different look-back periods (for reasons explained in Discord but not worth rehashing here). If you want your DOB number, check out the report on the Reports tab. For the most part, this number shouldn't change often or have huge swings, so having it front and center on app-launch seems a bit unnecessary. Lastly, the Overspent and Over-budgeted metrics were removed as well due to the fact that there is nothing you can do within Lumy (at this point) to take action on those, so they weren't really helpful.

## 1.21.2

- Fixes a bug that caused `Starting Balance` transactions to be included as income when they shouldn't be
- Allows transactions without a payee to be included as income (this matches native YNAB). Previously, they were filtered out and not shown which could've impacted figures for folks who don't assign a Payee to their income transactions.

## 1.21.0

**Frugal Months**

Past Frugal Months have been removed from the Reports Tab and are now viewable by going to Settings; they're under the Data section.

**Recurring Transactions (New feature)**

_Note_: This feature is rolling out slowly.

A Recurring Transactions report has been added to the General section of the Reports Tab. Inside, you'll find two ways to view your recurring transactions:
- In the Payees Tab, you'll see your recurring transactions listed by payee. This is an easy way to view all of your recurring transactions and their frequency. At this time, they're ordered from highest total amount to lowest, but let us know if you would like different sorting capabilities. We've also added a toggle to show all amounts as annual amounts which can sometimes be enlightening and allow you to better ask the question, "Is this worth it?".
- In the Timeline Tab, you'll see your recurring transactions laid out by when they will next occur. The timeline goes for a full _year_, showing each instance of all your recurring transactions. We've left this basic for now, but let us know what else you'd like to see on the timeline!

_Note_: Right now, the categories selected on the Reports Tab influence the transactions shown on this screen. Let us know if you think we should add the ability to filter categories and/or accounts specifically for this report like we do with Income v Expense.

**Other**

A bit of design work was done to offer more real estate to visuals like charts.

## 1.20.0

- The Spend by Category Pie chart now shows percentages of total spend for both category groups and categories for the selected timeframe and Category View. It also preserves the ability to "dive in" by tapping a category group. When doing that, the percentage shown for each category is the percentage of spend of the selected category group. This is similar (maybe even identical) to how it works natively in YNAB's Reflect report.
- Similar to the above, the Spend by Payee Pie chart now shows percentages of total spend for the selected timeframe and Category View.
- Fixes a bug where some charts weren't getting the memo about an updated Category View and were sticking with the old one.

## 1.19.2

**Frugal Months**

Frugal Months got a bit of love with this update, check out the deets below:

- When creating a Frugal Month, you now select the categories and accounts first. Then, when setting a target limit, the selected categories and accounts are used to suggest a limit that is 90% of average spending.
- Now, when creating a Frugal Month for the *current* month, you will no longer be able to accidentally set a limit that is less than you've already spent for the month.
- The projected spending shown on the Frugal Month chart is more granular; rather than an average daily spend being applied to all days in the month, each day has its _own_ average spending. This means that if you generally have a lot of spending on certain days, the projection should reflect that, rather than the line simply being linear.
- Because of the above, the status shown for a Frugal Month is more accurate. The status now correctly utilizes the _expected_ spending (based on the projection) to determine whether you're on track or not.

As always, please reach out in Discord, on Reddit, or via email if you see anything funky with these changes!

**General**

- Fixes a few minor bugs you (probably) haven't noticed!

## 1.18.9

- Fixes a bug in the Targets Health Report that sometimes caused incorrect spent amounts to be shown, leading to incorrect analysis of a target's health.
- Fixes overflow of long category names in transaction rows
- Ensures users are logged out if they revoke their token from YNAB settings.

**Goals Beta**
- Adds ability to edit a debt goal's target date (or remove it completely).

## 1.18.7

**General**
- Revamps dialogs across the app to better fit the platform.

**Goals Beta**
- Adds ability to delete and rename goals (still only debt goals are supported).
- Changes the behavior for determining a debt goal's original balance. Now, when a goal is created, the remaining balance is used. You can change the original balance (for instance, if you want it to reflect your mortgage's original balance) by tapping the menu on the Goal Details screen and tapping Edit Balances. Note that this is a breaking change and since goals are still in beta, you will need to delete and recreate existing goals.
- Fixes other minor goals bugs!

## 1.18.0

- Debt Goals have begun rolling out to beta testers. Want to test them out and give feedback? Feel free to join the Discord server, hop into #feat-goals, and let us know! You can join the server from Settings by tapping Join the Community.
- Fixes a visual bug related to the pages in the Spend by Category Pie chart for some users.
- Fixes a bug that caused inputting currency amounts during frugal month creation to misbehave for currency formats that did not include a decimal separator.

## 1.17.12

- Changes the percent remaining calculation for category groups in the Budget Burndown to more accurately reflect the amount remaining in the group (shown via the progress bar). Previously, the percent was an average of all the remaining percents for categories in that group. Now it is the percent remaining of the initial balance, which is more accurate.
- Fixes a bug that could have prevented some users with Firefox set to their default browser from being able to log in.
- Fixes a bug in category selection when creating Category Views or Frugal Months that caused it to be impossible to choose certain categories in a specific order.
- Fixes a bug that caused the app to fail to launch for users with completed Frugal Months.

## 1.17.9

- Fixes the color of the Budget Tab title

## 1.17.8

- Allows spend trackers to consider tracking accounts. Note that some conditions are not compatible with tracking accounts, such as "Is Income" and "Is Expense", or "Category Is" because tracking accounts transactions do not have categories. We've added "Is Outflow" and "Is Inflow" to support filtering tracking account transactions.
- Fixes a pesky out of memory bug that could have happened when modifying a category view.
- Fixes a bug that caused account state changes to require an app restart before being reflected in the app.
- Some more UI polishing as we prepare for the Goals (Beta) feature to be released soon. Stay tuned!
- Minor performance improvement

## 1.17.0

- Adds support for re-authenticating with YNAB if for some reason your access token becomes invalid. Invalid access tokens should be extremely rare, but if you happen to see a broken wifi symbol that won't go away on any of the 3 tabs of the Home Screen, head to the Settings tab and tap Reconnect to YNAB to re-authenticate.
- Minor bug fixes

**UI Improvements**
- Introduces a bit of a face lift to most parts of the app.
- We've reduced redundant language and UI elements where they didn't add value. This is most obvious in Settings.
- We also cleaned up a few interactions, like moving chart-type selection (for charts that support multiple types) to the chart details screen and removing it from the primary reports page. This preserves the ability to change the type without cluttering the UI you look at most often.
- Settings has been re-organized to make the options you need most often more accessible. 
- The Month in Review feature has been moved to the Reports tab. Soon we'll be enabling the ability to choose any month to review, so we feel this is a more appropriate place for it to live.

## 1.16.8

- Apologies for the delays since the last release! This release includes a lot (and when we say a lot, we mean a LOT) of under-the-hood changes to the core of the app. These changes will supercharge our abilities to deliver new and awesome features very soon, so stay tuned! Be on the lookout for bugs that may have snuck in with these changes, and please report them if you find any (you can reach out via the app or in our Discord server!).
- As a result of these changes, the app's performance should be improved across the board.
- Allows matching against accounts in the Advanced Spend Tracker query builder. This means you can now create a query that only includes transactions from specific accounts. One example use case for this is to track spending on a credit card for which you're trying to maximize rewards or meet a minimum spend requirement.
- Adds the highest and lowest spent months to the Spend Tracker details screen. Also, breaks up the metrics into a few sections.
- Adds a new line to the Spent This Month (STM) widget (on iOS) that shows last month's spend. This mirrors what you see on the Budget Tab inside the app.
- Corrects the chart on the Left to Spend (LTS) widget (on iOS) so that the reduction in LTS corresponds to only the spend from the current frugal month's categories, if one is active. Previously the reduction corresponded to all spending in the current month, potentially causing it to look like you spent more than you really did.
- Ensures alphabetical spend tracker ordering considers nicknames during the sort. This fixes an issue where, for instance, a spend tracker for the red flag (originally named "red") that was renamed to "balloons" would be sorted as if it was still named "red". Now, it's sorted by the name "balloons".
- Fixes two bugs with the Advanced Spend Tracker query builder. First, editing an AST that utilized "is not true" conditions now correctly restores them (previously they would be restored as "is true" conditions, requiring you to manually change them back). Secondly, you can now use the multi-select feature (ability to specify more than one category, payee etc.) as deep in the query as you want. Previously it was only supported at the top level.

## 1.15.6

- Allows viewing the Month in Review experience for the entire month. Previously, it was hidden after the first half of the month, but by popular demand, it's here all month!
- Allows creating a Frugal Month at any point during the month. Previously you could only create one for the current month within the first week of the month.
- Some minor performance improvements and bug fixes.

## 1.15.4

- Fixes a bug that might've caused some users to see a force upgrade screen when first opening the app after installing it.
- Tweaks the Reports tab color to make it more vibrant and easier to read.

## 1.15.2

- Changes the income and expense trend and comparison visualizations to use the latest 12 months of data in the new Month in Review. Because our budgets change as often as we do, using larger ranges of data is less meaningful; particularly for folks that hide categories or have other large changes in their budget. This change should make the trend and comparison visualizations more accurate and actionable.
- Replaces Age of Money on the Budget Tab with Days of Buffer. Age of Money is a bit of a nebulous metric with a slower feedback loop, particularly for credit card users. Days of Buffer, on the other hand, tells you how many days you could survive without any new income. This is a more concrete metric that can help you make better financial decisions.

## 1.15.1

- Minor bug fixes and optimizations.

## 1.15.0

- Adds Savings Rate Metric to the Month in Review report. Note that this is part of the new and improved Month in Review which is slowly rolling out. If you don't catch it this time around, it'll be available to you for June's Month in Review!
- Fixes Category Search during Spend Tracker creation.
- Fixes an issue with the Budget Burndown section for categories with a negative balance.
- Improves loading experience on the Budget tab.
- Makes a few minor UI tweaks--feedback is always welcome!

## 1.14.11

- Switches budget burndown to use amount values rather than percentages. This allows you to more easily determine what's left for spending by category while still being able to see the amount a category has "burned down" via the bar (which is still based on the percent remaining for the category or group).

## 1.14.10

- Fixes another account filtering bug related to the Income v Expense chart; specifically account filtering was not being respected when considering income (1.14.7 fixed the issue for expenses). Sorry about that!
- Removes the Spend by Day of Week chart. This chart was not particularly actionable and was one of the remnants of the original Lumy app (when Lumy was primarily just a cute way to view your YNAB data). As Lumy matures, we're focusing on actionable data and features that help you make better financial decisions. If you have any feedback on this change, please let us know! Also, if you'd like to be a bigger part of decisions like these, feel free to join our Discord via Settings.
- Fixes a few minor UI issues.

## 1.14.9

- Separates open and closed accounts when choosing accounts throughout the app.
- Ensures only open accounts can be selected when creating a new Frugal Month.

## 1.14.8

- Fixes a bug that caused the budget burndown chart to show data from the previous month for users who live in a timezone with a positive offset when compared to UTC and also refreshed the app after the month had changed in their timezone but before the new month in UTC. Current month data should now always be up-to-date for the current month, but please let us know if you see anything funky!

## 1.14.7

- Fixes account filtering on Income v Expense, Spend by Category and Spend by Payee charts.

## 1.13.7

- Fixes a bug that caused some settings to not be saved when the app restarted.

## 1.13.6

- Fixes the Export functionality which was broken in 1.10.1 release with the introduction of category groups to Category Views. You can now export your data again!
- Addresses some underlying issues with the authentication logic that could've caused annoying behavior like authentication dialogs popping up when they shouldn't have or trouble reaching the YNAB server. This is a big change, so please let us know if you notice any issues!

**Previous release notes can be found [here](https://lumyforynab.app/release-notes).**
