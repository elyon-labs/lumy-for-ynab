

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."category_view_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "category_view_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."category_view_categories" OWNER TO "postgres";


COMMENT ON TABLE "public"."category_view_categories" IS 'Categories selected for category views';



CREATE TABLE IF NOT EXISTS "public"."category_view_category_groups" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "category_view_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_group_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."category_view_category_groups" OWNER TO "postgres";


COMMENT ON TABLE "public"."category_view_category_groups" IS 'Category groups selected for category views';



CREATE TABLE IF NOT EXISTS "public"."category_views" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "budget_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."category_views" OWNER TO "postgres";


COMMENT ON TABLE "public"."category_views" IS 'Category views created by users';



CREATE TABLE IF NOT EXISTS "public"."devices" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "platform" "text" NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."devices" OWNER TO "postgres";


COMMENT ON TABLE "public"."devices" IS 'Devices belonging to users';



CREATE TABLE IF NOT EXISTS "public"."frugal_month_accounts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "frugal_month_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."frugal_month_accounts" OWNER TO "postgres";


COMMENT ON TABLE "public"."frugal_month_accounts" IS 'Accounts selected for a frugal month';



CREATE TABLE IF NOT EXISTS "public"."frugal_month_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "frugal_month_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."frugal_month_categories" OWNER TO "postgres";


COMMENT ON TABLE "public"."frugal_month_categories" IS 'Categories selected for a frugal month';



CREATE TABLE IF NOT EXISTS "public"."frugal_months" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "budget_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "month" "date" NOT NULL,
    "target_amount" bigint NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."frugal_months" OWNER TO "postgres";


COMMENT ON TABLE "public"."frugal_months" IS 'Frugal months created by users';



CREATE TABLE IF NOT EXISTS "public"."spend_tracker_conditions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "parent_id" "uuid" DEFAULT "gen_random_uuid"(),
    "type" "text" NOT NULL,
    "user_id" "uuid"
);


ALTER TABLE "public"."spend_tracker_conditions" OWNER TO "postgres";


COMMENT ON TABLE "public"."spend_tracker_conditions" IS 'Conditions associated with spend trackers';



CREATE TABLE IF NOT EXISTS "public"."spend_tracker_tests" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "condition_id" "uuid" DEFAULT "gen_random_uuid"(),
    "type" "text" NOT NULL,
    "value" "text",
    "user_id" "uuid"
);


ALTER TABLE "public"."spend_tracker_tests" OWNER TO "postgres";


COMMENT ON TABLE "public"."spend_tracker_tests" IS 'Tests associated with spend trackers';



CREATE TABLE IF NOT EXISTS "public"."spend_trackers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "condition_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "budget_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nickname" "text",
    "user_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);


ALTER TABLE "public"."spend_trackers" OWNER TO "postgres";


COMMENT ON TABLE "public"."spend_trackers" IS 'Spend trackers owned by users';



CREATE TABLE IF NOT EXISTS "public"."transaction_template_sub_transactions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "category_id" "uuid" DEFAULT "gen_random_uuid"(),
    "amount" bigint DEFAULT '0'::bigint NOT NULL,
    "is_inflow" boolean DEFAULT false NOT NULL,
    "payee_id" "uuid" DEFAULT "gen_random_uuid"(),
    "memo" "text",
    "template_id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."transaction_template_sub_transactions" OWNER TO "postgres";


COMMENT ON TABLE "public"."transaction_template_sub_transactions" IS 'Sub-transactions belonging to transaction templates.';



CREATE TABLE IF NOT EXISTS "public"."transaction_templates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "amount" bigint DEFAULT '0'::bigint NOT NULL,
    "is_inflow" boolean DEFAULT false NOT NULL,
    "account_id" "uuid" DEFAULT "gen_random_uuid"(),
    "payee_id" "uuid" DEFAULT "gen_random_uuid"(),
    "category_id" "uuid" DEFAULT "gen_random_uuid"(),
    "memo" "text",
    "flag" "text",
    "fire_immediately" boolean DEFAULT false NOT NULL,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "budget_id" "uuid" NOT NULL
);


ALTER TABLE "public"."transaction_templates" OWNER TO "postgres";


COMMENT ON TABLE "public"."transaction_templates" IS 'Templates created by users';



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "email" "text" NOT NULL,
    "ynab_user_id" "uuid" NOT NULL
);


ALTER TABLE "public"."users" OWNER TO "postgres";


COMMENT ON TABLE "public"."users" IS 'Users of Lumy';



CREATE OR REPLACE VIEW "public"."v_spend_tracker_conditions_flat" WITH ("security_invoker"='on') AS
 WITH RECURSIVE "condition_tree" AS (
         SELECT "st"."id" AS "spend_tracker_id",
            "st"."name" AS "spend_tracker_name",
            "st"."nickname" AS "spend_tracker_nickname",
            "st"."budget_id",
            "st"."user_id",
            "st"."created_at" AS "spend_tracker_created_at",
            "c"."id" AS "condition_id",
            "c"."parent_id",
            "c"."type" AS "condition_type",
            0 AS "depth"
           FROM ("public"."spend_trackers" "st"
             JOIN "public"."spend_tracker_conditions" "c" ON (("st"."condition_id" = "c"."id")))
        UNION ALL
         SELECT "ct_1"."spend_tracker_id",
            "ct_1"."spend_tracker_name",
            "ct_1"."spend_tracker_nickname",
            "ct_1"."budget_id",
            "ct_1"."user_id",
            "ct_1"."spend_tracker_created_at",
            "c"."id",
            "c"."parent_id",
            "c"."type",
            ("ct_1"."depth" + 1)
           FROM ("public"."spend_tracker_conditions" "c"
             JOIN "condition_tree" "ct_1" ON (("c"."parent_id" = "ct_1"."condition_id")))
        )
 SELECT "ct"."spend_tracker_id",
    "ct"."spend_tracker_name",
    "ct"."spend_tracker_nickname",
    "ct"."budget_id",
    "ct"."user_id",
    "ct"."condition_id",
    "ct"."parent_id",
    "ct"."condition_type",
    "ct"."depth",
    "t"."id" AS "test_id",
    "t"."type" AS "test_type",
    "t"."value" AS "test_value",
    "ct"."spend_tracker_created_at"
   FROM ("condition_tree" "ct"
     LEFT JOIN "public"."spend_tracker_tests" "t" ON (("t"."condition_id" = "ct"."condition_id")))
  ORDER BY "ct"."spend_tracker_id", "ct"."depth", "ct"."condition_id";


ALTER VIEW "public"."v_spend_tracker_conditions_flat" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_category_views" WITH ("security_invoker"='on') AS
 SELECT "cv"."id",
    "cv"."budget_id",
    "cv"."created_at",
    "cv"."name",
    COALESCE("cvc"."categories", '{}'::"uuid"[]) AS "categories",
    COALESCE("cvcg"."category_groups", '{}'::"uuid"[]) AS "category_groups"
   FROM (("public"."category_views" "cv"
     LEFT JOIN ( SELECT "category_view_categories"."category_view_id",
            "array_agg"("category_view_categories"."category_id") AS "categories"
           FROM "public"."category_view_categories"
          WHERE ("category_view_categories"."category_id" IS NOT NULL)
          GROUP BY "category_view_categories"."category_view_id") "cvc" ON (("cv"."id" = "cvc"."category_view_id")))
     LEFT JOIN ( SELECT "category_view_category_groups"."category_view_id",
            "array_agg"("category_view_category_groups"."category_group_id") AS "category_groups"
           FROM "public"."category_view_category_groups"
          WHERE ("category_view_category_groups"."category_group_id" IS NOT NULL)
          GROUP BY "category_view_category_groups"."category_view_id") "cvcg" ON (("cv"."id" = "cvcg"."category_view_id")));


ALTER VIEW "public"."v_user_category_views" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_frugal_months" WITH ("security_invoker"='on') AS
 SELECT "fm"."id",
    "fm"."budget_id",
    "fm"."created_at",
    "fm"."target_amount",
    "fm"."month",
    COALESCE("fmc"."category_ids", '{}'::"uuid"[]) AS "category_ids",
    COALESCE("fma"."account_ids", '{}'::"uuid"[]) AS "account_ids"
   FROM (("public"."frugal_months" "fm"
     LEFT JOIN ( SELECT "frugal_month_categories"."frugal_month_id",
            "array_agg"("frugal_month_categories"."category_id") AS "category_ids"
           FROM "public"."frugal_month_categories"
          WHERE ("frugal_month_categories"."category_id" IS NOT NULL)
          GROUP BY "frugal_month_categories"."frugal_month_id") "fmc" ON (("fm"."id" = "fmc"."frugal_month_id")))
     LEFT JOIN ( SELECT "frugal_month_accounts"."frugal_month_id",
            "array_agg"("frugal_month_accounts"."account_id") AS "account_ids"
           FROM "public"."frugal_month_accounts"
          WHERE ("frugal_month_accounts"."account_id" IS NOT NULL)
          GROUP BY "frugal_month_accounts"."frugal_month_id") "fma" ON (("fm"."id" = "fma"."frugal_month_id")));


ALTER VIEW "public"."v_user_frugal_months" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_transaction_templates" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::timestamp with time zone AS "created_at",
    NULL::"uuid" AS "user_id",
    NULL::bigint AS "amount",
    NULL::boolean AS "is_inflow",
    NULL::"uuid" AS "account_id",
    NULL::"uuid" AS "payee_id",
    NULL::"uuid" AS "category_id",
    NULL::"text" AS "memo",
    NULL::"text" AS "flag",
    NULL::boolean AS "fire_immediately",
    NULL::"text" AS "name",
    NULL::"uuid" AS "budget_id",
    NULL::"jsonb" AS "sub_transactions";


ALTER VIEW "public"."v_user_transaction_templates" OWNER TO "postgres";


ALTER TABLE ONLY "public"."category_view_category_groups"
    ADD CONSTRAINT "category_view_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."category_view_categories"
    ADD CONSTRAINT "category_view_categories_pkey1" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."category_views"
    ADD CONSTRAINT "category_views_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."devices"
    ADD CONSTRAINT "devices_pkey" PRIMARY KEY ("id", "user_id");



ALTER TABLE ONLY "public"."frugal_month_accounts"
    ADD CONSTRAINT "frugal_month_accounts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."frugal_month_categories"
    ADD CONSTRAINT "frugal_month_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."frugal_months"
    ADD CONSTRAINT "frugal_months_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."frugal_months"
    ADD CONSTRAINT "frugal_months_user_budget_month_uniq" UNIQUE ("user_id", "budget_id", "month");



ALTER TABLE ONLY "public"."spend_tracker_conditions"
    ADD CONSTRAINT "spend_tracker_conditions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."spend_tracker_tests"
    ADD CONSTRAINT "spend_tracker_tests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."spend_trackers"
    ADD CONSTRAINT "spend_trackers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."transaction_template_sub_transactions"
    ADD CONSTRAINT "transaction_template_sub_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."transaction_templates"
    ADD CONSTRAINT "transaction_templates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."category_view_categories"
    ADD CONSTRAINT "unique_category_view_category" UNIQUE ("category_id", "category_view_id");



ALTER TABLE ONLY "public"."category_view_category_groups"
    ADD CONSTRAINT "unique_category_view_category_group" UNIQUE ("category_group_id", "category_view_id");



ALTER TABLE ONLY "public"."frugal_month_accounts"
    ADD CONSTRAINT "unique_frugal_month_account" UNIQUE ("account_id", "frugal_month_id");



ALTER TABLE ONLY "public"."frugal_month_categories"
    ADD CONSTRAINT "unique_frugal_month_category" UNIQUE ("category_id", "frugal_month_id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_category_view_categories_view_id" ON "public"."category_view_categories" USING "btree" ("category_view_id");



CREATE INDEX "idx_category_view_category_groups_view_id" ON "public"."category_view_category_groups" USING "btree" ("category_view_id");



CREATE INDEX "idx_category_views_user_id" ON "public"."category_views" USING "btree" ("user_id");



CREATE INDEX "idx_frugal_months_user_id" ON "public"."frugal_months" USING "btree" ("user_id");



CREATE INDEX "idx_spend_trackers_condition_id" ON "public"."spend_trackers" USING "btree" ("condition_id");



CREATE OR REPLACE VIEW "public"."v_user_transaction_templates" WITH ("security_invoker"='on') AS
 SELECT "tt"."id",
    "tt"."created_at",
    "tt"."user_id",
    "tt"."amount",
    "tt"."is_inflow",
    "tt"."account_id",
    "tt"."payee_id",
    "tt"."category_id",
    "tt"."memo",
    "tt"."flag",
    "tt"."fire_immediately",
    "tt"."name",
    "tt"."budget_id",
    COALESCE("jsonb_agg"("jsonb_build_object"('id', "st"."id", 'created_at', "st"."created_at", 'category_id', "st"."category_id", 'amount', "st"."amount", 'is_inflow', "st"."is_inflow", 'payee_id', "st"."payee_id", 'memo', "st"."memo")) FILTER (WHERE ("st"."id" IS NOT NULL)), '[]'::"jsonb") AS "sub_transactions"
   FROM ("public"."transaction_templates" "tt"
     LEFT JOIN "public"."transaction_template_sub_transactions" "st" ON (("st"."template_id" = "tt"."id")))
  GROUP BY "tt"."id";



ALTER TABLE ONLY "public"."category_view_category_groups"
    ADD CONSTRAINT "category_view_categories_category_view_id_fkey" FOREIGN KEY ("category_view_id") REFERENCES "public"."category_views"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."category_view_categories"
    ADD CONSTRAINT "category_view_categories_category_view_id_fkey1" FOREIGN KEY ("category_view_id") REFERENCES "public"."category_views"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."category_views"
    ADD CONSTRAINT "category_views_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."devices"
    ADD CONSTRAINT "devices_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."frugal_month_accounts"
    ADD CONSTRAINT "frugal_month_accounts_frugal_month_id_fkey" FOREIGN KEY ("frugal_month_id") REFERENCES "public"."frugal_months"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."frugal_month_categories"
    ADD CONSTRAINT "frugal_month_categories_frugal_month_id_fkey" FOREIGN KEY ("frugal_month_id") REFERENCES "public"."frugal_months"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."frugal_months"
    ADD CONSTRAINT "frugal_months_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."spend_tracker_conditions"
    ADD CONSTRAINT "spend_tracker_conditions_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."spend_tracker_conditions"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."spend_tracker_conditions"
    ADD CONSTRAINT "spend_tracker_conditions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."spend_tracker_tests"
    ADD CONSTRAINT "spend_tracker_tests_condition_id_fkey" FOREIGN KEY ("condition_id") REFERENCES "public"."spend_tracker_conditions"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."spend_tracker_tests"
    ADD CONSTRAINT "spend_tracker_tests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."spend_trackers"
    ADD CONSTRAINT "spend_trackers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transaction_template_sub_transactions"
    ADD CONSTRAINT "transaction_template_sub_transactions_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "public"."transaction_templates"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transaction_templates"
    ADD CONSTRAINT "transaction_templates_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Allow authenticated users to delete their own frugal month acco" ON "public"."frugal_month_accounts" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_accounts"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to delete their own frugal month cate" ON "public"."frugal_month_categories" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_categories"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to insert their own frugal month acco" ON "public"."frugal_month_accounts" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_accounts"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to insert their own frugal month cate" ON "public"."frugal_month_categories" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_categories"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to update their own frugal month acco" ON "public"."frugal_month_accounts" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_accounts"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_accounts"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to update their own frugal month cate" ON "public"."frugal_month_categories" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_categories"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_categories"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to view their own frugal month accoun" ON "public"."frugal_month_accounts" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_accounts"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow authenticated users to view their own frugal month catego" ON "public"."frugal_month_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."frugal_months"
  WHERE (("frugal_month_categories"."frugal_month_id" = "frugal_months"."id") AND ("frugal_months"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Allow users to delete their own spend tracker conditions" ON "public"."spend_tracker_conditions" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to delete their own spend tracker tests" ON "public"."spend_tracker_tests" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to insert their own spend tracker conditions" ON "public"."spend_tracker_conditions" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to insert their own spend tracker tests" ON "public"."spend_tracker_tests" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to read their own spend tracker conditions" ON "public"."spend_tracker_conditions" FOR SELECT USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to read their own spend tracker tests" ON "public"."spend_tracker_tests" FOR SELECT USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to update their own spend tracker conditions" ON "public"."spend_tracker_conditions" FOR UPDATE USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to update their own spend tracker tests" ON "public"."spend_tracker_tests" FOR UPDATE USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Enable insert for users based on user_id" ON "public"."devices" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable insert for users based on user_id" ON "public"."frugal_months" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable insert for users based on user_id" ON "public"."users" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));



CREATE POLICY "Enable users to view their own data only" ON "public"."devices" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable users to view their own data only" ON "public"."frugal_months" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Enable users to view their own data only" ON "public"."users" FOR SELECT TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "id"));



CREATE POLICY "Users can delete sub-transactions of their own templates" ON "public"."transaction_template_sub_transactions" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."transaction_templates"
  WHERE (("transaction_templates"."id" = "transaction_template_sub_transactions"."template_id") AND ("transaction_templates"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can delete their own category view categories" ON "public"."category_view_categories" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_categories"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can delete their own category view category groups" ON "public"."category_view_category_groups" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_category_groups"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can delete their own category views" ON "public"."category_views" FOR DELETE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can delete their own frugal months" ON "public"."frugal_months" FOR DELETE TO "authenticated" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));



CREATE POLICY "Users can delete their own spend trackers" ON "public"."spend_trackers" FOR DELETE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can delete their own transaction templates" ON "public"."transaction_templates" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can insert sub-transactions into their own templates" ON "public"."transaction_template_sub_transactions" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."transaction_templates"
  WHERE (("transaction_templates"."id" = "transaction_template_sub_transactions"."template_id") AND ("transaction_templates"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can insert their own category view categories" ON "public"."category_view_categories" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_categories"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can insert their own category view category groups" ON "public"."category_view_category_groups" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_category_groups"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can insert their own category views" ON "public"."category_views" FOR INSERT TO "authenticated" WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can insert their own spend trackers" ON "public"."spend_trackers" FOR INSERT TO "authenticated" WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can insert their own transaction templates" ON "public"."transaction_templates" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can read sub-transactions of their own templates" ON "public"."transaction_template_sub_transactions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."transaction_templates"
  WHERE (("transaction_templates"."id" = "transaction_template_sub_transactions"."template_id") AND ("transaction_templates"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can read their own transaction templates" ON "public"."transaction_templates" FOR SELECT USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can update sub-transactions of their own templates" ON "public"."transaction_template_sub_transactions" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."transaction_templates"
  WHERE (("transaction_templates"."id" = "transaction_template_sub_transactions"."template_id") AND ("transaction_templates"."user_id" = "auth"."uid"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."transaction_templates"
  WHERE (("transaction_templates"."id" = "transaction_template_sub_transactions"."template_id") AND ("transaction_templates"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can update their own category view categories" ON "public"."category_view_categories" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_categories"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_categories"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can update their own category view category groups" ON "public"."category_view_category_groups" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_category_groups"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_category_groups"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can update their own category views" ON "public"."category_views" FOR UPDATE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid"))) WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can update their own data" ON "public"."users" FOR UPDATE TO "authenticated" USING (("id" = ( SELECT "auth"."uid"() AS "uid"))) WITH CHECK (("id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can update their own devices" ON "public"."devices" FOR UPDATE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid"))) WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can update their own frugal months" ON "public"."frugal_months" FOR UPDATE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid"))) WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can update their own spend trackers" ON "public"."spend_trackers" FOR UPDATE TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid"))) WITH CHECK (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can update their own transaction templates" ON "public"."transaction_templates" FOR UPDATE USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can view their own category view categories" ON "public"."category_view_categories" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_categories"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can view their own category view category groups" ON "public"."category_view_category_groups" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."category_views"
  WHERE (("category_views"."id" = "category_view_category_groups"."category_view_id") AND ("category_views"."user_id" = ( SELECT "auth"."uid"() AS "uid"))))));



CREATE POLICY "Users can view their own category views" ON "public"."category_views" FOR SELECT TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



CREATE POLICY "Users can view their own spend trackers" ON "public"."spend_trackers" FOR SELECT TO "authenticated" USING (("user_id" = ( SELECT "auth"."uid"() AS "uid")));



ALTER TABLE "public"."category_view_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."category_view_category_groups" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."category_views" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."devices" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."frugal_month_accounts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."frugal_month_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."frugal_months" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."spend_tracker_conditions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."spend_tracker_tests" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."spend_trackers" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."transaction_template_sub_transactions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."transaction_templates" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";








































































































































































GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_categories" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_categories" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_categories" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_category_groups" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_category_groups" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_view_category_groups" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_views" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_views" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."category_views" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."devices" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."devices" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."devices" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_accounts" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_accounts" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_accounts" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_categories" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_categories" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_month_categories" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_months" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_months" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."frugal_months" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_conditions" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_conditions" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_conditions" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_tests" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_tests" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_tracker_tests" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_trackers" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_trackers" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."spend_trackers" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_template_sub_transactions" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_template_sub_transactions" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_template_sub_transactions" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_templates" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_templates" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."transaction_templates" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_spend_tracker_conditions_flat" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_spend_tracker_conditions_flat" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_spend_tracker_conditions_flat" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_category_views" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_category_views" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_category_views" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_frugal_months" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_frugal_months" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_frugal_months" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_transaction_templates" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_transaction_templates" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."v_user_transaction_templates" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "service_role";






























RESET ALL;
