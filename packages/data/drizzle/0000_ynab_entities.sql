CREATE TABLE `account_debt_months` (
	`account_id` text NOT NULL,
	`month` text NOT NULL,
	`budget_id` text NOT NULL,
	`interest_rate` integer,
	`minimum_payment` integer,
	`escrow_amount` integer,
	PRIMARY KEY(`account_id`, `month`),
	FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `account_debt_months_by_budget` ON `account_debt_months` (`budget_id`);--> statement-breakpoint
CREATE TABLE `accounts` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`name` text NOT NULL,
	`type` text NOT NULL,
	`on_budget` integer NOT NULL,
	`closed` integer NOT NULL,
	`deleted` integer NOT NULL,
	`balance` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `accounts_by_budget` ON `accounts` (`budget_id`,`name`);--> statement-breakpoint
CREATE TABLE `budgets` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`first_month` text,
	`last_month` text,
	`last_modified_on` text
);
--> statement-breakpoint
CREATE TABLE `currency_formats` (
	`budget_id` text PRIMARY KEY NOT NULL,
	`iso_code` text NOT NULL,
	`decimal_digits` integer NOT NULL,
	`decimal_separator` text NOT NULL,
	`symbol_first` integer NOT NULL,
	`group_separator` text NOT NULL,
	`currency_symbol` text NOT NULL,
	`display_symbol` integer NOT NULL,
	`example_format` text NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `categories` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`category_group_id` text NOT NULL,
	`name` text NOT NULL,
	`hidden` integer NOT NULL,
	`deleted` integer NOT NULL,
	`sort_order` integer NOT NULL,
	`target_type` text,
	`target_needs_whole_amount` integer,
	`target_day` integer,
	`target_cadence` integer,
	`target_cadence_frequency` integer,
	`target_creation_month` text,
	`target_balance` integer,
	`target_month` text,
	`target_percentage_complete` integer,
	`target_months_to_budget` integer,
	`target_under_funded` integer,
	`target_overall_funded` integer,
	`target_overall_left` integer,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`category_group_id`) REFERENCES `category_groups`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `categories_by_group` ON `categories` (`category_group_id`,`sort_order`);--> statement-breakpoint
CREATE INDEX `categories_by_budget` ON `categories` (`budget_id`);--> statement-breakpoint
CREATE TABLE `category_groups` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`name` text NOT NULL,
	`hidden` integer NOT NULL,
	`deleted` integer NOT NULL,
	`sort_order` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `category_groups_by_budget` ON `category_groups` (`budget_id`,`sort_order`);--> statement-breakpoint
CREATE TABLE `category_months` (
	`category_id` text NOT NULL,
	`month` text NOT NULL,
	`budget_id` text NOT NULL,
	`budgeted` integer NOT NULL,
	`activity` integer NOT NULL,
	`balance` integer NOT NULL,
	PRIMARY KEY(`category_id`, `month`),
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `category_months_by_month` ON `category_months` (`budget_id`,`month`);--> statement-breakpoint
CREATE TABLE `months` (
	`budget_id` text NOT NULL,
	`month` text NOT NULL,
	`note` text,
	`income` integer NOT NULL,
	`budgeted` integer NOT NULL,
	`activity` integer NOT NULL,
	`to_be_budgeted` integer NOT NULL,
	`age_of_money` integer,
	`deleted` integer NOT NULL,
	PRIMARY KEY(`budget_id`, `month`),
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `payees` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`name` text NOT NULL,
	`deleted` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `payees_by_budget` ON `payees` (`budget_id`,`name`);--> statement-breakpoint
CREATE TABLE `scheduled_subtransactions` (
	`id` text PRIMARY KEY NOT NULL,
	`scheduled_transaction_id` text NOT NULL,
	`budget_id` text NOT NULL,
	`amount` integer NOT NULL,
	`payee_id` text,
	`category_id` text,
	`memo` text,
	`transfer_account_id` text,
	`deleted` integer NOT NULL,
	FOREIGN KEY (`scheduled_transaction_id`) REFERENCES `scheduled_transactions`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `scheduled_subtransactions_by_parent` ON `scheduled_subtransactions` (`scheduled_transaction_id`);--> statement-breakpoint
CREATE INDEX `scheduled_subtransactions_by_budget` ON `scheduled_subtransactions` (`budget_id`);--> statement-breakpoint
CREATE TABLE `scheduled_transactions` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`date_first` text NOT NULL,
	`date_next` text NOT NULL,
	`frequency` text NOT NULL,
	`account_id` text NOT NULL,
	`account_name` text NOT NULL,
	`amount` integer NOT NULL,
	`payee_id` text,
	`payee_name` text,
	`category_id` text,
	`category_name` text,
	`memo` text,
	`flag_color` text,
	`flag_name` text,
	`transfer_account_id` text,
	`deleted` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `scheduled_transactions_by_budget` ON `scheduled_transactions` (`budget_id`,`date_next`);--> statement-breakpoint
CREATE TABLE `server_knowledge` (
	`budget_id` text NOT NULL,
	`resource` text NOT NULL,
	`month` text DEFAULT '' NOT NULL,
	`knowledge` integer NOT NULL,
	`synced_at` text NOT NULL,
	PRIMARY KEY(`budget_id`, `resource`, `month`),
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `subtransactions` (
	`id` text PRIMARY KEY NOT NULL,
	`transaction_id` text NOT NULL,
	`budget_id` text NOT NULL,
	`amount` integer NOT NULL,
	`payee_id` text,
	`payee_name` text,
	`category_id` text,
	`category_name` text,
	`memo` text,
	`transfer_account_id` text,
	`transfer_transaction_id` text,
	`deleted` integer NOT NULL,
	FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `subtransactions_by_transaction` ON `subtransactions` (`transaction_id`);--> statement-breakpoint
CREATE INDEX `subtransactions_by_budget` ON `subtransactions` (`budget_id`);--> statement-breakpoint
CREATE TABLE `transactions` (
	`id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`date` text NOT NULL,
	`account_id` text NOT NULL,
	`amount` integer NOT NULL,
	`payee_id` text,
	`payee_name` text,
	`category_id` text,
	`category_name` text,
	`memo` text,
	`flag_color` text,
	`cleared` text NOT NULL,
	`approved` integer NOT NULL,
	`transfer_account_id` text,
	`transfer_transaction_id` text,
	`matched_transaction_id` text,
	`import_id` text,
	`deleted` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `transactions_by_match` ON `transactions` (`matched_transaction_id`);--> statement-breakpoint
CREATE INDEX `transactions_by_budget` ON `transactions` (`budget_id`,`date`);