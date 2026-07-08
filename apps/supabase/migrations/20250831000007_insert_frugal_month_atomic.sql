-- Create atomic frugal month insertion function
CREATE OR REPLACE FUNCTION insert_frugal_month_atomic(
  p_user_id UUID,
  p_budget_id UUID,
  p_month TEXT,
  p_target_amount INTEGER,
  p_category_ids UUID[],
  p_account_ids UUID[]
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_frugal_month_id UUID;
  v_category_id UUID;
  v_account_id UUID;
BEGIN
  -- Insert the frugal month
  INSERT INTO frugal_months (user_id, budget_id, month, target_amount)
  VALUES (p_user_id, p_budget_id, p_month::DATE, p_target_amount)
  RETURNING id INTO v_frugal_month_id;
  
  -- Insert frugal month categories
  FOREACH v_category_id IN ARRAY p_category_ids
  LOOP
    INSERT INTO frugal_month_categories (category_id, frugal_month_id)
    VALUES (v_category_id, v_frugal_month_id);
  END LOOP;
  
  -- Insert frugal month accounts
  FOREACH v_account_id IN ARRAY p_account_ids
  LOOP
    INSERT INTO frugal_month_accounts (account_id, frugal_month_id)
    VALUES (v_account_id, v_frugal_month_id);
  END LOOP;
  
  RETURN v_frugal_month_id;
END;
$$;