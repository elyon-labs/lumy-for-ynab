DROP INDEX `ledger_by_account_date`;--> statement-breakpoint
DROP INDEX `ledger_by_group_month`;--> statement-breakpoint
DROP INDEX `ledger_spend_by_month`;--> statement-breakpoint
CREATE INDEX `ledger_by_account_month` ON `ledger_entries` (`budget_id`,`account_id`,`month`,`amount`);--> statement-breakpoint
CREATE INDEX `ledger_by_group_month` ON `ledger_entries` (`budget_id`,`category_group_id`,`month`,`amount`);--> statement-breakpoint
CREATE INDEX `ledger_spend_by_month` ON `ledger_entries` (`budget_id`,`month`,`category_id`,`amount`) WHERE is_expense = 1;