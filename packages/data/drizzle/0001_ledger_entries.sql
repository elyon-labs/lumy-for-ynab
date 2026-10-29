CREATE TABLE `ledger_entries` (
	`entry_id` text PRIMARY KEY NOT NULL,
	`budget_id` text NOT NULL,
	`transaction_id` text NOT NULL,
	`is_subtransaction` integer NOT NULL,
	`date` text NOT NULL,
	`month` text NOT NULL,
	`account_id` text NOT NULL,
	`payee_id` text,
	`payee_name` text,
	`category_id` text,
	`category_group_id` text,
	`amount` integer NOT NULL,
	`memo` text,
	`flag_color` text,
	`transfer_account_id` text,
	`transfer_pair_key` text,
	`is_transfer` integer NOT NULL,
	`is_income` integer NOT NULL,
	`is_starting_balance` integer NOT NULL,
	`is_expense` integer NOT NULL,
	FOREIGN KEY (`budget_id`) REFERENCES `budgets`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `ledger_by_date` ON `ledger_entries` (`budget_id`,`date`,`entry_id`);--> statement-breakpoint
CREATE INDEX `ledger_by_category_month` ON `ledger_entries` (`budget_id`,`month`,`category_id`);--> statement-breakpoint
CREATE INDEX `ledger_by_payee_month` ON `ledger_entries` (`budget_id`,`month`,`payee_id`);--> statement-breakpoint
CREATE INDEX `ledger_by_account_date` ON `ledger_entries` (`budget_id`,`account_id`,`date`);--> statement-breakpoint
CREATE INDEX `ledger_by_group_month` ON `ledger_entries` (`budget_id`,`category_group_id`,`month`);--> statement-breakpoint
CREATE INDEX `ledger_by_transaction` ON `ledger_entries` (`transaction_id`);--> statement-breakpoint
CREATE INDEX `ledger_spend_by_month` ON `ledger_entries` (`budget_id`,`month`) WHERE is_expense = 1;