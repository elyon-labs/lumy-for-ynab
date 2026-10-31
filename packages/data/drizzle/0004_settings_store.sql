CREATE TABLE `settings` (
	`key` text NOT NULL,
	`scope` text DEFAULT '' NOT NULL,
	`value` text NOT NULL,
	PRIMARY KEY(`key`, `scope`)
);
