---
layout: "../layouts/MarkdownLayout.astro"
title: "Release Notes"
---
**Newer release notes can be found in the app!**

## 1.13.1

- Adds the ability to multi-select items when building conditions for the Advanced Spend Tracker query builder. For example, when choosing a category, you can now select more than one category. Upon saving, a new condition will be added for every category that was selected. This should make it easier to build complex queries.
- Adds the ability to edit Advanced Spend Trackers. This change is rolling out slowly to ensure it's stable before everyone gets it. If you don't see it yet, you will soon!

## 1.12.0

- The current Frugal Month, as well as the ability to plan your next Frugal Month, are both now shown on the Budget Tab. Past Frugal Months remain on the Reports Tab.
- Adds a setting to Budget Tab settings that allows you to configure whether to use the currently active Frugal Month's Left to Spend metric or the budget's Left to Spend metric in the Highlights section. By default, the Frugal Month's Left to Spend metric is shown if one is active. Note that if the actual (budget's) Left to Spend is less than the Frugal Month's, the actual Left to Spend will be shown. This should help to avoid overspending.
- Fixes a bug that caused deleted categories to be shown when creating a Category View. This was a visual bug only and did not affect the actual data.

## 1.11.1

- Fixes a bug in the Budget Burndown Chart that caused categories that had not been funded or spent from to appear funky.

## 1.11.0

- Adds a trackball to the Spent This Month Chart, allowing you to see the exact amount spent on a specific day for this month and last month.
- The Budget Burndown Chart has gotten a facelift and is ready for more testing. We'll roll this out slowly again to ensure it's working as expected. If you don't see it yet, you will soon!
- Trackballs (the little tooltips that pop up when you tap and drag on a chart) are now activated on long press. This makes it cooperate better with panning on the chart, and also improves the scrolling experience (trackballs no longer show accidentally when scrolling).

## 1.10.2

- Fixes a bug that caused an error when attempting to create a Category View from the Month in Review feature.

## 1.10.1

- Adds the ability to specify category groups when creating Category Views. This means that new categories will be automatically added to a Category View if the category's group matches the group specified in the Category View. This should make it easier to manage Category Views as your budget grows and changes. **Note**: If you've previously created a Category View that intended to capture all categories in a specific category group, you will need to delete and re-create that Category View to take advantage of this new feature.
- Changes the method by which categories are selected for Income v Expense and Month in Review reports. These now use Category Views, so you can reuse your existing views to specify which categories you're interesting in seeing for each report. In each of these places, you can now create a new Category View or select an existing one to filter the data shown in the report.
- Removes categories that have not been budgeted for from the budget burndown chart.
- Makes it so the entire category name shows on the budget burndown chart for easier viewing. This may be changed in a future release.

## 1.9.2

- Adds the Budget Burndown Chart to the Budget tab. This chart shows how much money remains in the budget for each category for the current month. Throughout the month, the bars are reduced by spending, giving you a visual representation of how much money you have left to spend in each category. This chart is rolling out slowly to all users.
- Minor UI tweaks and bug fixes.

## 1.8.4

- Fixes a bug that caused the data in the Highlights section on the Budget tab to be incorrect. If you still see any inconsistencies or issues, please don't hesitate to reach out!

## 1.8.3

- Fixes another Income v Expense bug related to income transactions comprised of complex splits. Users who input income transactions as split transactions where some of the sub-transactions had empty payees but others did not may have had data integrity issues specific to their income. That's fixed in this version.
- Removes the hard-coded `+` sign from in front of income values in the Income v Expense report. Previously, users with a negative income value would've seen their income presented like `+-$1000`, which... makes no sense. Now, it will be presented as `-$1000`.
- Ensures query results are sorted correctly (descending by date) in the Advanced Spend Tracker query builder. This should make it easier to see the most recent transactions that match your query.
- Fixes several bugs related to the Month in Review feature

## 1.8.1

- Adds the ability to view the categories that are overspent when overspending occurs. From the budget tab, tap the Overspent row in the Highlights section to see a list of categories that are overspent.
- Fixes a minor bug related to split income transactions where all sub transactions had different payees than the parent transaction. This resulted in a minor display bug in the Income v Expense report where the payee for the parent transaction would appear with $0 income (since all income was from the sub transaction payees). All numbers were correct and matched YNAB, but the display was a bit off. Now, the payee for the parent transaction will no longer appear in the report, which also matches YNAB.

## 1.7.2

- Fixes an issue for users that may have hidden charts that were removed in a previous version.

## 1.7.1

- The Left to Spend metric on the Budget tab is now offset by categories with negative balances. For example, if all categories with positive balances total $1000 but there is one category with overspending of $50, your total Left to Spend will be $950. Previously, the Left to Spend metric would have been $1000.
- Fixes an issue with the new pie charts for users with > 5 category groups.
- Fixes a bug that caused Overspending and Overbudgeting not to appear on the Highlights section of the Budget tab.

## 1.7.0

- Adds notifications for the Month in Review feature.
- Fixes a minor bug in the new pie charts.

## 1.6.1

- Allows filtering the Month in Review report by categories to ensure you see only the data you want to see each month.
- Fixes relative percentages on new pie charts to ensure the sum of all slices correctly represents the data on the current page.
- Credit Card Payment category balances are no longer included in the Budget Tab "Left to Spend" calculation. The rationale here is that the money in those categories is already "spoken for" (via previous spending) and is therefore no longer "left to spend".

## 1.5.0

- Fixes a few bugs from the chart revamp in 1.4.0.
- Adds Latest Transactions section to the Budget Tab that shows the most recent transactions in the budget (according to the Budget Tab's configured Category View). This is rolling out slowly to all users.
- Renames Daily Net Income to Smoothed Income to better reflect what the chart shows.

## 1.4.0

**General**

- Lots of under-the-hood cleanup and simplification to make it easier to iterate on the next big features, namely BYOC (build-your-own-chart).

**Charts**

_Note_: Due to the size of these changes, they will be rolling out slowly for testing, so if you don't see them yet...You will soon!

- Completely revamps pie charts to make them cleaner and easier to interact with.
- Consolidates charts that displayed the same data in different chart types into a single tile that can be toggled based on your preference. The chart type you choose (e.g bar vs line) is saved and will be the default for future sessions. This should clean up the Reports tab a bit and reduce confusion about why the same data is displayed in multiple charts.

## 1.3.2

- Fixes a bug that caused transaction ordering to be broken in a few places in the app.

## 1.3.1

- Fixes a bug that may have caused the app to crash or behave oddly after upgrading from a very old version to 1.3.0.

## 1.3.0

**General**

- (Hopefully) fixes a bug that caused the authentication dialog to pop up when it shouldn't have. If you still see this and you haven't logged out, tapping `Cancel` should be fine.
- A little bit of Spring Cleaning to keep things tidy. 🧹
- Fixes a bug in the Income v Expense report that caused income to accidentally be filtered out when filtering categories out of the report.

**Spend Trackers**

- Refines the logic for matching Payees to ensure Spend Trackers that track Payees and the Spend by Payee chart are more accurate. This corrects some minor discrepancies in the data in these locations. We love data accuracy!
- Fixes a bug that caused spend trackers to not inherit changes to entity names (such as payee, category, & category group). There's still a known issue where the _transactions themselves_ will not be updated with the correct name following a name change. This seems to be a limitation of the YNAB API and we're reaching out to them to see if that is expected behavior.

**Frugal Months**

- Adds "Left to Spend" and Net Income to the Frugal Month details screen, so you know how much you have left to spend in the month and how much you've saved by spending less!
- Ensures the transactions on the See Transactions screen are sorted in descending order by date like the rest of the app.
- Fixes a minor bug with split transactions that may have caused them not to be counted as spend in some cases.

## 1.2.2

- Introduces the Budget tab, which aims to be the "one stop shop" for getting the high level important information regarding your budget. We'll continue to build this tab out, and feedback on what you'd like to see there is always welcome! In this release, we've added the Highlights section which details things like your Age of Money, what's left to spend in the budget, and whether there's any overspending or overbudgeting in the current month. Additionally, you can now track your spending for the current month in real time with a comparison to the previous month.
- The Metrics tab has been renamed to Reports to better reflect the content that lives there. This tab will continue to be the home for more detailed reports and metrics. The charts that previously lived on the Charts tab now live here. This should feel familiar to YNAB users who are used to the "Reports" tab in the first party app.
- Adds Top 3 Spending Categories to the Expenses section of the Month in Review
- Adds a new Metrics section to the Month in Review, currently featuring the change in your Days of Buffer.
- Refines the Month in Review experience in general, cleaning it up and adding a bit of polish.
- Fixes several small bugs, including the import functionality.

## 1.1.1

- Allows creating a frugal month for the next month at any time. Until the month starts, the frugal month will have a Not Started status.
- Adds a card at the top of the Charts tab that warns users who do not have their currency configured correctly in YNAB. This has led folks to assume Lumy does not allow curriences other than USD, but Lumy actually uses whatever currency formatting you have set in YNAB. If you're seeing this card, please make sure your currency is set correctly in YNAB. If you're still having issues, please reach out!
- Fixes a bug with the Daily Net Income chart that sometimes reported a lower net income when the current range consisted of days without spending.
- Fixes a few minor UI bugs from the 1.0.0 release.

## 1.0.0

- 🎉 Version 1.0.0 is here! This version marks the first "stable" version of Lumy. Counterintuitively, nothing has _really_ changed that should impact the stability of the application, but Lumy has been given a fresh coat of paint that adds refinement and a more clearly identifiable brand. This sadly means doing away with custom themes, which were hard to maintain, distracted from Lumy's branding, and were not always accessible. As always, if you have any feedback (positive or otherwise!) please feel free to leave it using the feedback feature or join our Discord!
- In order to allow us to improve Lumy in a more thoughtful and deliberate way, we've changed how the app handles analytics. Just like before, no personal data is ever collected (i.e nothing about your finances or budget is ever sent to us, it all remains on your device). However, we now collect more information about how the app is used to help us make more informed decisions about what to work on next. If you had previously opted into analytics collection, nothing has changed. If you hadn't, this just means some non-personal information is sent for the sole purpose of improving Lumy. If you have any questions or concerns, please reach out to us via the feedback feature or on Discord. Please note that the app store listings have been updated to reflect this change.

## 0.0.175

- Minor bug fixes and performance improvements.

## 0.0.174

- Fixes a bug that could have prevented some users from logging in. This was only an issue in 0.0.173.

## 0.0.173

- Adds an initial version of Month in Review that will roll out after beta testing. This feature will allow you to see a summary of your month's spending and income. It will also highlight trends in spending and income over the past 12 months. We embedded a feedback form right into the feature, so please let us know what you want to see in future versions of Month in Review! When the feature is available to you, it will be on the Metrics tab under reports.
- Adds the ability to Select All & Deselect All when choosing categories and accounts in various places in the app.
- Fixes a bug that was causing April Frugal Months to have the status "Not Started" when April had in fact already started.
- Some minor UI polish and bug fixes.

## 0.0.170

- Removes Privacy Mode from Settings. This feature was not widely used and was causing some confusion. If you'd like to see it return, please let us know via the Feedback feature!

## 0.0.169

- Fixes a bug that caused duplicate Frugal Months to be created. If you ran into this, you can safely delete the duplicate.
- Fixes a bug that caused users to not be prompted to enable Frugal Month notifications when creating a new Frugal Month.

## 0.0.167

- Fixes an issue that caused some line charts to be blank when only a single month timeframe was selected.

## 0.0.166

- Adds quality of life improvements to charts--specifically you can now tap and drag your finger to scrub through the data on the chart. This should make it easier to see the data you're interested in.
- Adds trendlines to line charts to aid in visualizing which direction you're headed in. This applies to the Daily Net Income chart, Income v Expense chart, and Spend Tracker charts. You can disable trendlines by navigating to Settings and then Charts.

## 0.0.164

- Adds the ability to filter the income v. expense report by accounts.
- Some performance improvements to address minor performance degradation that was observed in the previous release.

## 0.0.162

- Adds the ability to select which accounts you want to include in each chart. You can select accounts by navigating to a chart's details (tap on the "stat" in the top right corner of a chart), and then tapping the "Select accounts" tile.
- Fixes a bug that caused new charts to be hidden. As a result of this fix, you may need to "re-hide" previously hidden charts... sorry about that!
- Fixes a bug that caused pie charts to break when changing category views or accounts.
- Fixes transaction ordering in several places including the income v expense report, chart transactions, and Spend Tracker transactions.

## 0.0.159

- Minor improvements to Frugal Months (still rolling out!)
- Performance improvements and bug fixes

## 0.0.157

- Introduces Frugal Months, a feature that allows you to set a spending limit for a month and track your progress towards that limit.
- Some UI polish here and there, specifically around buttons that are presented at the bottom of lists.

## 0.0.155

- Fixes the Spend Tracker details chart.

## 0.0.154

- More bug fixes for Advanced Spend Trackers.

## 0.0.152

- Fixes an issue that caused incorrect duplicate detection in the Advanced Spend Tracker query builder.
- Fixes an issue that caused errors when attempting to view Spend Tracker data.

## 0.0.151

- Minor UI tweaks
- Other minor under-the-hood improvements.

## 0.0.150

- Shows results of the condition being built when creating an Advanced Spend Tracker, allowing you to verify your query is returning the transactions you expect.
- Other minor under-the-hood improvements.

## 0.0.149

- Some improvements to chart colors and visuals to improve readability and cohesiveness across all charts.

## 0.0.148

- Some fixes to the currency abbreviation to allow for more granularity at smaller intervals.
- Adds privacy policy and terms of use to the About screen.

## 0.0.147

- Some minor changes to theming including less shadows, less rounded corners, and charts with more real estate.
- Adds abbreviation of Y axis currency values to give charts more breathing room.
- Adds descriptions back to spend tracker screens for non-Advanced Spend Trackers.
- Fixes a bug in the Advanced Spend Tracker query builder that made it challenging to create a memo-based condition.
- Increases error handling around the Advanced Spend Tracker query builder to make it more clear when something goes wrong.
- Changes the behavior of income v expense and daily net income charts to no longer change to displaying data by day/week for smaller timeframes, as this was causing a lot of confusion.
- Removes the setting (and default behavior) for charts to _not_ show details on the Home Screen. This added complexity that wasn't very valuable. We'd prefer to make charts look beautiful even with their details shown.

## 0.0.146

- Adds latest 6 and 12 month options to the timeframe selection screen.
- Fixes a few bugs.

## 0.0.145

- Fixes a couple issues related to Advanced Spend Trackers.

## 0.0.143

- Introduces Advanced Spend Trackers. This is a new type of Spend Tracker that allows you to specify a query using infinite conditions that will be used to filter transactions. For example, you could create a Spend Tracker that tracks all transactions with a memo that contains the word "coffee" AND has the payee Starbucks, allowing you to track only the coffee you purchase from Starbucks.

## 0.0.142

- Fixes an issue that caused renaming a Category View to accidentally rename *all* Category Views.

## 0.0.141

- Fixes an issue that caused renaming Category Views to not work.

## 0.0.140

- Fixes an issue that caused renaming Spend Trackers to not work.

## 0.0.137

- 🎉 **New Chart:** Introduces the Income v Expense (Bar) chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find! **Also**, there is an existing (known) bug that causes new charts to be hidden by default if you've ever hidden charts before. You can find the new chart by going to **Settings** and then **Charts** and **Select and reorder charts**.

## 0.0.136

- Fixes the 'Others' slices in the pie charts which were being incorrectly labeled.
- Fixes an issue that was causing some pie chart labels to not show.

## 0.0.133

- Under-the-hood improvements to prepare for much bigger things to come! Stay tuned.

## 0.0.132

- Includes more Spend by Payee chart fixes. Most importantly, fixes a bug that caused payees to be counted more than once for split transactions. Additionally, fixes a bug that caused the calculated percentages to be incorrect.
- Refined the logic that excludes emojis from pie chart labels. This should make it more accurate and less likely to exclude non-emoji characters.

## 0.0.130

- Fixes a couple bugs in the Spend by Payee chart, namely one that caused the chart to become grey when a category view with very few categories was selected.
- Excludes "unsafe" characters from the labels shown on pie charts. This means emojis won't be shown there, but can be seen on the tooltips and in the Look Closer screens. This is a temporary workaround while we await a fix for https://github.com/syncfusion/flutter-widgets/issues/1611.
- Adds a requirement to fill out the email address when sending feedback, as we've received several feature requests for features that exist already, and we'd love to be able to respond to those folks to let them know about the feature they're looking for.

## 0.0.129

- Adds better compatibility with tablets and landscape mode. If you're using a tablet or a phone in landscape mode and still having issues, please leave feedback. Be sure to leave your email address so that we can follow up with you about specifics as needed.

## 0.0.128

- Allows for renaming memo and flag Spend Trackers. Previously, these could not be renamed.
- To avoid potential confusion following a rename, and to make it easier to understand what a Spend Tracker is tracking, the Spend Tracker detail screen now shows the value of the category, category group, payee, memo or flag that the Spend Tracker is tracking. Previously, it only showed the _name_ of the Spend Tracker.

## 0.0.127

- Adds spend values to the Look Closer screens for the Spend by Category and Spend by Category Group charts. This aligns them with the Spend by Payee chart, which already showed spend values.

## 0.0.126

- 🎉 **New Chart:** Introduces the Spend by Payee (Pie) chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find! **Also**, there is an existing (known) bug that causes new charts to be hidden by default if you've ever hidden charts before. You can find the new chart by going to **Settings** and then **Charts** and **Select and reorder charts**.

## 0.0.125

- Minor under-the-hood improvements

## 0.0.124

- Fixes the tooltips on the Net Worth chart which were not showing.
- Fixes the Latest 3 Months calculation on the Timeframe picker.
- Adds percentages to the Spend by Category and Spend by Category Group charts.
- Addresses spacing issues in the time frame choosing screen.
- Fixes the 'Others' slice on pie charts to use a negative spend value to align with other slices.
- Fixes an issue where changes made to a Category View's categories would not be immediately reflected in charts.

## 0.0.123

- Includes more tweaks to pie chart colors.

## 0.0.122

- Fixes a bug that prevented the 'Others' slice on the Spend by Category and Spend by Category Group charts from showing a tooltip.
- No longer shows deleted categories, category groups, or payees as options when creating Spend Trackers.
- Ensures all days of week are labeled on the Spend by Day of Week chart.
- Adds variance in color to pie charts to make it easier to distinguish between slices.

## 0.0.120

- Fixes a currency formatting bug that caused some currencies to not display correctly.

## 0.0.119

- "Fixes" a few chart bugs that cropped up as a result of updating the charts library (fixes in quotes because we just downgraded the library for now until they're resolved).

## 0.0.118

- Fixes a bug that may have prevented users from logging in.

## 0.0.117

- Spend Trackers sorted alphabetically are now more predictably sorted. Emojis are ignored and the remainder of the name is treated as case insensitive.
- Adds a setting allowing you to choose whether or not to show the detailed view of charts on the Home Screen. This setting is off by default, but can be enabled by navigating to Settings -> Charts and tapping the "Detailed charts everywhere" tile.

## 0.0.116

- Fixes an issue where currency formats that used no decimal digits would cause the app to misbehave.
- Allows for Spend Trackers to be sorted by name. In doing this, we introduced a breaking change that caused Spend Trackers to lose any ordering they had previously. Sorry about that! We'll try to avoid breaking changes like this in the future.
- Ensures that Spend Trackers that are tracking a category, category group, or payee stay in sync with the name of the respective entity. In other words, if you change the name of a category, category group, or payee, the Spend Tracker will update to reflect that change. Previously this was not the case, and you'd have to delete and re-create the Spend Tracker to get the new name.
- Allows the renaming of Spend Trackers that follow a category, category group, or payee. If this is done, the Spend Tracker will no longer update to reflect the name of the respective entity. This is useful if you want to track a category, category group, or payee but want to give it a different name in Lumy.
- Fixes an issue that caused the Hidden Charts and Change Budget bottom sheets to not fully scroll to allow for selecting items at the bottom of the list.

## 0.0.115

- Adds legends to charts containing multiple series. This should make it easier to understand what each series represents.
- Splits the Spend by Category pie chart into Spend by Category and Spend by Category Group charts.
- Fixes a bug that caused the category view selection button on the Home Screen to look funky on iOS.

## 0.0.113

- Fixes an issue where currency formats that used a space as the group separator and comma as the decimal separator would cause the app to misbehave.

## 0.0.112

- Displays the currently selected timeframe on the Home Screen. This should make it easier to see what timeframe you're looking at when you open the app.
- Adds a note to the Net Worth chart that calls out the API limitation described in previous releases and links to the relevant Toolkit issue.
- Shows a detailed view of all charts on the Chart Details screen. In a future release we'll add a setting to allow for *always* showing the detailed view on the Home Screen.

## 0.0.110

- We've basically rewritten the core of the app to support more rapid development of new features and charts. This should allow us to release new features and charts more quickly and with fewer bugs. If you notice any issues, please reach out!
- Fixes formatting for some currencies such as JPY.
- Fixes an issue where axis labels looked funky in the Spend by Category bar chart when category names contained an ellipsis.
- Fixes an issue on the Net Worth chart that caused some months to report incorrect data when a debt account had a positive balance and vice versa. Note that the Net Worth data for budgets with loan accounts is still not 100% accurate due to a limitation in the YNAB API.

## 0.0.107

- Fixes a bug in the Days of Buffer chart where it would display an error if a single month was selected and no income transactions had occurred yet in the month.

## 0.0.106

- Adds the ability to enable or disable charts, allowing you to choose to only display the charts that are meaningful to you.
- Adds the ability to order your Spend Trackers.

## 0.0.104

- Small calculation fix to Days of Buffer chart
- Ensures a valid timeframe is selected when switching between budgets with incompatible `firstMonth` values. For example, prior to this fix, switching from a budget with a `firstMonth` of `2021-01-01` to a budget with a `firstMonth` of `2023-02-01` could cause the selected timeframe to include dates that were not valid for the second budget.

## 0.0.103

- Revamps all charts. Specifically, bar charts now allow zooming and panning.
- Separates assets and liabilities in the Net Worth chart, and shows a trend line for the calculated net worth. This closely matches the first party app's Net Worth chart.
- Tooltips now persist for a few seconds after tapping a chart element, making it easier to see the data you're interested in.
- Currency formatting now more closely aligns with the settings configured in YNAB for the currently selected budget.
- All categories are now shown on the Spend by Category chart.

## 0.0.99

- Adds the ability to see the transactions associated with specific charts; specifically the Spend by Category charts and Spend by Day of Week chart.

## 0.0.98

- Opts to not show a trend chart on the Spend Tracker detail screen when a single-month timeframe is selected (the chart was blank in this case, so it didn't provide any value).
- Fixes a bug with the Daily Net Income chart that caused errors when there were months without income in the chart.

## 0.0.97

- Fixes a bug that prevented users from creating the first Spend Tracker.

## 0.0.96

- Adds a "Here's the math" tile to Days of Buffer and Daily Net Income charts. These tiles aim to highlight the specifics of the calculation that leads to the chart's values. This is useful for folks who want to understand how the data is calculated, and for folks who want to double check that the data is accurate. If you have any questions about the math, please reach out!
- Allows creating Spend Trackers from the Home Screen. No more digging through Settings to create one.

## 0.0.95

- Features a line graph on the Spend Tracker detail screen that shows the amount of money spent over time for the selected category/payee/memo keyword.
- Some cleanup of UI elements to make things a bit more consistent.
- Allows tapping the status bar to scroll to the top of any tab on the Home Screen on iOS.

## 0.0.94

- Sorts Income v Expense Category/Payee screens by the amount of money spent/earned.
- Sorts transactions lists in descending (by date) order (this mirrors YNAB's approach).
- Home screen now scrolls to the top of the screen when tapping the navigation bar item for the currently selected tab.

## 0.0.93

- Attempts to fix a crash that was sometimes seen during app launch (this crash was related to the app re-authenticating with YNAB servers).
- Fixes the Discord link in the Settings screen.
- A few under-the-hood performance tweaks.

## 0.0.92

- Fixes a calculation error in the Net Worth chart. The most recent month was always correct, but prior months were wrong in a few circumstances. Note that there is a known issue with budgets that contain a mortgage account that we're looking into.
- Fixes a bug that caused the Income v Expense report to be incorrect. This was introduced in version 0.0.90. Sorry about that!
- Allows selecting hidden categories when creating category views and when creating spend trackers.

## 0.0.90

- Primarily a performance release. For the nerdy out there, this release pushes expensive iteration operations to a background `Isolate` to avoid blocking the main thread. This helps to avoid skipped frames and should make the app feel a bit better for those with lots of transaction data.
- You may notice that your selected date range was reset. This was necessary as some data storage mechanisms needed to change to support the above, but it shouldn't happen again.
- Introduces privacy mode, a feature that can be toggled on or off in Settings and serves to hide account balances and transaction amounts across the app. This is useful for showing Lumy to friends or taking screenshots of the app without leaking private details.

## 0.0.88

- Changes the Income v Expense chart stat to show averages for the currently selected timeframe instead of the last dates income and expense.
- Shows a badge on the Income v Expense screen filter icon when a category view is selected so that you're aware you've filtered out some categories.
- Adds a bit of UI polish.

## 0.0.87

- Tweaks the Timeframe choosing UI to be a full screen modal instead of a bottom sheet. This allowed for more breathing room to provide timeframe presets (currently YTD, This Month, Latest 3 Months, Last Year and This Year).
- Adds a "stat" to each chart--a small text field that shows the most relevant information for that chart so that you can see what you care about most without needing to interact with the chart.
- Since the "stat" replaces the menu icon, tapping the stat brings you to the chart details. You'll notice that viewing the chart's data is not possible as of this release. This is because we're working on a new way to view the data that will highlight more useful/meaningful information without all the clutter of the existing experience.
- To support the above, lots of improvements went into the core logic of the application. This should make it easier to add new charts and features in the future. Please let us know if you find any bugs!

## 0.0.85

- Adds ability to see Category Groups on the Spend by Category (Pie) chart. Tap the cycle icon to change between seeing Category Groups and Categories.
- Fixes a bug that sometimes caused sync issues between YNAB and Lumy that could not be rectified. Reach out to us on Discord or via the Feedback screen if you think your data is out of sync.
- Moves the Settings entrypoint to the bottom of the Home Screen as a tab. Only the current Category View is shown at the top of the Home Screen now.
- Changes Income v Expense so that it respects the currently selected Category View. You can now change the Category View directly from Income v Expense as well. Feedback is welcome on this change! Let us know if you think the Category View selected on the Income v Expense screen should not change the global one (i.e it should be unique to just that report/screen).

## 0.0.84

- Fixes calculation for Spend Tracker average monthly spending metric so it's now 100% accurate
- Fixes a bug in the Spend by Category charts where "special transactions" (like starting balance transactions) were causing errors.

## 0.0.83

- Adds the ability to create a Spend Tracker for a Category Group
- Adds average weekly and monthly spend (for the selected timeframe) to the Spend Tracker metrics.

## 0.0.82

- Fixes an issue where split transactions whose sub-transactions did *not* have payee information would throw off the Income v Expense report. Shout-out to @Staxed on Discord for reporting and helping debug this one!
- Various bits of UI cleanup and polish
- Makes places where we list budgets (during login and in settings) more dynamic so that folks with lots of budgets can see them all

## 0.0.81

- 🎉 **New Chart:** Introduces the Spend by Category (Pie) chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find!
- Fixes a couple bugs related to the toggling of the data usage setting introduced in `0.0.76`
- Fixes a bug related to Income v Expense calculation that caused Starting Balance transactions categorized to show up in expenses
- Fixes a bug that caused using the pull-to-refresh functionality to introduce syncing issues between Lumy & YNAB

## 0.0.78

- Fixes a bug that may have caused funkiness in fetching transactions for some users.
- Fixes a bug where tooltips displayed on charts would interfere with surrounding UI elements
- Fixes bugs in the Spend over Time chart and Paid Daily chart where data wasn't reflected correctly for the current month when viewing the chart "in months".

## 0.0.77

- Fixes an app startup bug related to the previous release.

## 0.0.76

- Changes app behavior to disable crash reporting and analytics gathering by default. These will only be enabled with user opt-in, and can be turned off at any time. Note that changes to this setting require a full app restart.

## 0.0.75

- More bug squashing to spend trackers!

## 0.0.74

- Fixes a bug that caused the Spend Tracker metrics to not be accurate in some cases.

## 0.0.73

- Fixes multiple bugs that caused some data inaccuracy (primarily in the Spend over Time and and Paid Daily charts) and cleans up a few things under the hood to avoid bugs in the future.

## 0.0.71

- Adds detail flows for the Income v Expense report. Previously, you could only see the summaries for each month on the Income v Expense report. Now, tapping a month will give you a choice of diving deeper into the Income or Expenses for that month. Tapping Income will show you the Payees you received income from. Tapping Expenses will show you the Categories you spent money in. From there, you can tap a Payee or Category to see their specific transactions. This should make it easier to see where your money is coming from and going to!

## 0.0.70

- Adds back Category Views which had mistakenly disappeared in a previous release. Sorry about that!

## 0.0.69

- Cleaning up some old cruft so formally feature flagged features show up on initial load to avoid any confusion.

## 0.0.68

- Still more bug fixes for the date range picker...
- Optimizations around API requests made during app startup. We now make fewer requests which saves on data usage and speeds up the app's startup time.

## 0.0.67

- More bug fixes for the date range picker!
- Removes the Spend Garden Chart, as it wasn't providing a ton of value. Most folks didn't really understand it, and even once you do, it's really more focused on past behavior with very little (if any) ability to influence future behavior. Decisions like this one are made in the Discord, so if you want to weigh in on future ones, feel free to join us there! Navigate to Settings and then Join the Community to join.

## 0.0.66

- Bug fixes for the date range picker.

## 0.0.65

- Introduces a new way to choose the duration of time for data display. Instead of only being allowed to choose a start date, you can now choose a _range_. This mirrors the YNAB date range selection approach and allows you to select "windows" of time. Future updates will include presets like "YTD" and "Last 3 months". This change should allow for more accurate and rapid development of features like Income v Expense reports.

## 0.0.64

- Minor bug fixes.

## 0.0.63

- Some general cleanup to the UI to make lists a bit nicer to look at
- Introduces the initial landing screen for an income expense report which is subject to change

## 0.0.62

- In celebration of YNAB's new branding, adds a blurple theme option to the app. As a reminder, custom themes is a beta feature.
- Separates charts and "metrics" into 2 tabs on the Home Screen, so you no longer have to scroll to the bottom of the Home Screen to see your Spend Trackers. This is also where the soon-to-launch income v expense report will go. If you have a better name than "metrics" for non-charty things, let me know!

## 0.0.58

- Adds the ability to configure "Category Views", which are groups of categories that you can switch between to change the category inputs for most charts. Some charts will continue to show the same data, such as the Net Worth chart, which isn't category specific. These are modeled after YNAB's "Views", so they should feel familiar. If something feels off, drop us some feedback!
- As a result of the above, the ability to configure categories and accounts for each chart has been removed. This decision was made because the prioritization of Category Views and chart-specific configuration felt unintuitive. The removal of account configuration was made because in most cases, charts operate on the entirety of the budget and their data may be inaccurate when not taking into consideration all accounts. If desired, account configuration may re-appear in the future.

## 0.0.57

- Adds a tooltip at the bottom of the Home Screen when a user has no Spend Trackers to encourage them to create one.
- Minor cleanup of the Home Screen items to make spacing a bit more consistent.

## 0.0.56

- Fixes an issue that caused the app to not load properly when a user's account did not contain a currency format.
- Fixes an issue where net worth values were accidentally being absolute value'd. This caused the net worth chart to be inaccurate in some cases.

## 0.0.55

- Adds a background to each chart to help with readability on the Home Screen.
- Removes some extra whitespace from list row items.
- Use Checkboxes instead of Switches for chart configuration, and slim those list items down even more.
- Fixes an issue that caused the Net Worth chart to not look so great when shared.
- Fixes an issue that caused emojis not to render correctly on the Spend by Category chart

## 0.0.53

- Fixes an issue that caused the app to crash when opening the external browser.
- Adds more information to the Net Worth chart's tooltips. They now show Assets & Liabilities separately, as well as the Net Worth.
- Fixes an issue with Net Worth chart's account configuration that caused weird behavior when changing the configuration.
- Disables Net Worth's chart "source" screen for now, as there's nothing too interesting to show there.

## 0.0.52

- 🎉 **New Chart:** Introduces the Net Worth chart. Currently it only shows the calculated net worth, but a soon-to-be-released version will have a bar for assets and liabilities, just like the first party app. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find!

## 0.0.51

- Fixed a bug where accounts using the `otherDebt` account type would prevent the app from loading correctly.

## 0.0.50

- Cleaned up the source screens for all charts to pave the way for even more cleanup.

## 0.0.49

- Tiny little release with a few minor bug fixes and improvements.

## 0.0.48

- Fixes a bug that caused custom category & account selection to not be respected by the Spend By Day of Week chart.
- Fixes yet another timezone-related bug that caused the Days of Buffer chart to look funky at certain times of the day. I think that is the last of the timezone bugs! 🤞
- Ensures that charts displaying data by week or month include the data from the first of the week and month respectively. For example, Days of Buffer chart now calculates and displays the current buffer for September 1. Previously, it wouldn't show September until September 2 came around.

## 0.0.47

- I asked ChatGPT to write me a poem about this release, so here it is:
```
In a world so vast, yet so small,
Developers face a problem that afflicts all,
Timezones, oh timezones, a pain to align,
Across continents, they intertwine.

Morning for one, night for another,
A meeting missed, 'Oh bother!',
Code commits and deploys, all a mess,
In this temporal game of chess.

A constant struggle to synchronize,
Annoyance grows, as the sun rises and dies,
Yet, in a world so connected, so grand,
Timezones are a reality, we must withstand.
```
- Besides _timezones_, a couple tweaks to date formatting on charts and their source data.
## 0.0.46

- Makes the Paid Daily chart a bit more dynamic by having it respond to the selected duration. Longer durations show averages by week and month, while shorter durations show the net inflow by day. This follows the same strategy as a few other charts.
- Adds transactions per week and transactions per month metrics to Spend Trackers. This is useful for seeing how often you transact for a given category, payee, memo keyword, etc.
- Fixes a few bugs related to dates/timezones. This should make the data in the app more accurate.

## 0.0.45

- Have we used the word "under-the-hood" enough? Because this release includes even more of those types of improvements. Soon enough you're going to think we're just a bunch of mechanics or something. 🙃
- Adds the ability to specify a custom duration for calculating data using a date picker. This is available on the Home Screen next to the existing preset durations. Hopefully we'll be able to add other presets like YTD and MTD, and maybe even the ability to choose a specific date range.

## 0.0.44

- The remainder of the chart source screens now have the newer look and feel that was introduced in 0.0.43.
- More under-the-hood improvements to support more rapid development of charts and features in the future.

## 0.0.43

- A lot of under-the-hood work to make sure calculations involving split transactions were correct.
- A revamp of the Spend Trackers transactions screen and the Spend by Category source screen. Much of this was made possible by the aforementioned under-the-hood work. You can expect the same revamp to come to the remainder of the Source screens in the near future!

## 0.0.42

- Fixes an issue where Split transactions were not represented in charts/data.

## 0.0.41

- Tweaks to Days of Buffer and Spend by Category charts to make them a bit more ✨ aesthetic ✨ 
- 🎉 **New Chart:** Introduces the Spend Over Time chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find!

## 0.0.40

- Bug fixes for Spend by Category chart

## 0.0.39

- Some polish and fixes for the new Days of Buffer chart
- Some color tweaks to make things look a bit more uniform throughout the app
- 🎉 **New Chart:** Introduces the Spend by Category chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find!

## 0.0.38

- Now that category and account configuration is available for all charts, we've removed the language from chart descriptions that indicates what accounts it includes.
- For the same reason, we also stopped filtering out transfer transactions from chart data. In some cases (namely, when transferring from an on-budget account to an off-budget account), the exclusion of these impacted the data meaningfully. When transferring between on-budget accounts, there is no impact on the data in most cases.
- 🎉 **New Chart:** Introduces the Days of Buffer chart. Please note that all new charts may have bugs and may not be 100% accurate. Please report any issues you find!

## 0.0.37

- Adds the ability to configure the accounts and categories that are included in a chart. For instance, if you don't want outflows in your savings categories to count towards spending in the Spend Garden chart, tap the menu on Spend Garden, navigate to "Categories & accounts" and deselect the savings categories.

## 0.0.36

- Adds the ability to create spend trackers based on flags.

## 0.0.35

- Fixes an issue where spend trackers would be shown for all budgets, rather than just the selected budget.
- Mostly under-the-hood cleanup and performance improvements
- In the works is the ability to configure each chart's source categories and accounts (current default for all charts is *all* categories and *on-budget* accounts).

## 0.0.34

- The previous version introduced Spend Trackers which was rolled out to a small group of users. One of our favorite features, they allow you to specify a category, payee, or word in a memo and track stats specific to that selection. For example, choose the Amazon payee to track all spending for that specific payee. Or choose the word "coffee" to track all spending that has the word "coffee" in the memo. Or choose the "Groceries" category to track all spending in that category. This feature is now available to all users for testing and feedback!
- Fixes a bug with Spend Trackers where only the absolute value of the total net spend was being shown. This made it appear as if you were net negative in cases when you were actually net positive. Whoops!
- Top used memo data is back as the "top used words in memos" metric. It's enabled by default (with customization of what you can enable/disable coming soon!). This introduces a new concept of "metrics", which are simple bits of metadata that give you further insight into fun things about your budget. More metrics are coming soon!

## 0.0.33

- We removed the Word Cloud chart as it was not providing much value. The data that backed it, however, is not lost! It will return in a future version in a different form.

## 0.0.32

- The app got a facelift by adopting some Material 3 components
- Some dialogs got a facelift too, in that they were migrated to bottom sheets. 

## 0.0.31

- Lots of work under the hood on a new feature that'll be coming soon!
- Some minor cleanup and performance improvements

## 0.0.30

- Fixed an issue that led to the Memo Word Cloud chart not always showing the correct data.

## 0.0.29

- Fixed an issue that led to both sides of matched transactions being included in charts and their source data. This was causing some charts to be inaccurate.
- Added the inflow transactions we use to calculate "daily income" to the Paid Daily chart source data. This makes it easy to see what inflows count toward the daily income calculation.
- Added an additional day of data to the Paid Daily chart, meaning it now shows 31 days of data instead of 30. This allows for a full month of income to be included when calculating the average daily income.

## 0.0.28

- Accessibility improvements
- Lots of under the hood tweaks and performance improvements as we get ready for folks to start testing the app and providing feedback.

## 0.0.27

- Just a bug fix or two in this one. More coming soon!

## 0.0.26

- Gave the spend garden chart a little more variance in the opacity of the boxes. Instead of being binary, there are now 4 "slots" a day's spending can fall into. This makes it a little easier to see the difference between days with a lot of spending and days with a little spending.

## 0.0.25

- Custom themes (very beta) are available with a few options (that might go away at any point...user be warned!)

## 0.0.23

- Fixed a bug that caused the currency format settings configured in YNAB to sometimes be ignored.
- Gave a little love to the duration selector on the Home Screen. It's now just the slightest bit more delightful.

## 0.0.22

- So it turns out Transaction payees can be null. Who knew? We handle that now.

## 0.0.21

- The **What's New** section is new! This is the first version that contains it. How meta!
- Fixes an issue where some older transactions did not have the correct (latest) metadata and may have been impacting charts.
