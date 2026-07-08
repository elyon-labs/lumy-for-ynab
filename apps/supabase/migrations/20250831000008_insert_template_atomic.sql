-- Create atomic template insertion function
CREATE OR REPLACE FUNCTION insert_template_atomic(
  p_user_id UUID,
  p_budget_id UUID,
  p_name TEXT,
  p_is_inflow BOOLEAN,
  p_amount INTEGER DEFAULT NULL,
  p_account_id UUID DEFAULT NULL,
  p_category_id UUID DEFAULT NULL,
  p_payee_id UUID DEFAULT NULL,
  p_memo TEXT DEFAULT NULL,
  p_fire_immediately BOOLEAN DEFAULT FALSE,
  p_flag TEXT DEFAULT NULL,
  p_sub_transactions JSONB DEFAULT '[]'::JSONB
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_template_id UUID;
  v_sub_transaction JSONB;
BEGIN
  -- Insert the transaction template
  INSERT INTO transaction_templates (
    budget_id, user_id, name, is_inflow, amount, account_id, 
    category_id, payee_id, memo, fire_immediately, flag
  )
  VALUES (
    p_budget_id, p_user_id, p_name, p_is_inflow, p_amount, p_account_id,
    p_category_id, p_payee_id, p_memo, p_fire_immediately, p_flag
  )
  RETURNING id INTO v_template_id;
  
  -- Insert sub-transactions if any exist
  IF jsonb_array_length(p_sub_transactions) > 0 THEN
    FOR v_sub_transaction IN SELECT * FROM jsonb_array_elements(p_sub_transactions)
    LOOP
      INSERT INTO transaction_template_sub_transactions (
        template_id, category_id, amount, is_inflow, payee_id, memo
      )
      VALUES (
        v_template_id,
        CASE WHEN v_sub_transaction->>'category_id' IS NOT NULL
             THEN (v_sub_transaction->>'category_id')::UUID
             ELSE NULL END,
        CASE WHEN v_sub_transaction->>'amount' IS NOT NULL 
             THEN (v_sub_transaction->>'amount')::INTEGER 
             ELSE NULL END,
        CASE WHEN v_sub_transaction->>'is_inflow' IS NOT NULL
             THEN (v_sub_transaction->>'is_inflow')::BOOLEAN
             ELSE NULL END,
        CASE WHEN v_sub_transaction->>'payee_id' IS NOT NULL
             THEN (v_sub_transaction->>'payee_id')::UUID
             ELSE NULL END,
        v_sub_transaction->>'memo'
      );
    END LOOP;
  END IF;
  
  RETURN v_template_id;
END;
$$;
