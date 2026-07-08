-- Create atomic template update function
CREATE OR REPLACE FUNCTION update_template_atomic(
  p_template_id UUID,
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
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_sub_transaction JSONB;
BEGIN
  -- Update the transaction template
  UPDATE transaction_templates 
  SET 
    name = p_name,
    is_inflow = p_is_inflow,
    amount = p_amount,
    account_id = p_account_id,
    category_id = p_category_id,
    payee_id = p_payee_id,
    memo = p_memo,
    fire_immediately = p_fire_immediately,
    flag = p_flag,
    updated_at = NOW()
  WHERE id = p_template_id;
  
  -- Delete existing sub-transactions for the template
  DELETE FROM transaction_template_sub_transactions 
  WHERE template_id = p_template_id;
  
  -- Insert new sub-transactions if any exist
  IF jsonb_array_length(p_sub_transactions) > 0 THEN
    FOR v_sub_transaction IN SELECT * FROM jsonb_array_elements(p_sub_transactions)
    LOOP
      INSERT INTO transaction_template_sub_transactions (
        template_id, category_id, amount, is_inflow, payee_id, memo
      )
      VALUES (
        p_template_id,
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
END;
$$;
