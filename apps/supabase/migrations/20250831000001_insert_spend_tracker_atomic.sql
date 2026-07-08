-- Create atomic spend tracker insertion function
CREATE OR REPLACE FUNCTION insert_spend_tracker_atomic(
  p_user_id UUID,
  p_budget_id UUID,
  p_condition JSONB,
  p_name TEXT,
  p_nickname TEXT DEFAULT NULL,
  p_created_at TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_root_condition_id UUID;
  v_spend_tracker_id UUID;
BEGIN
  -- Recursive function to insert condition and its children
  v_root_condition_id := insert_condition_recursive(p_condition, NULL, p_user_id);
  
  -- Insert the spend tracker
  INSERT INTO spend_trackers (name, budget_id, user_id, condition_id, nickname, created_at)
  VALUES (
    p_name,
    p_budget_id,
    p_user_id,
    v_root_condition_id,
    p_nickname,
    COALESCE(p_created_at, NOW())
  )
  RETURNING id INTO v_spend_tracker_id;
  
  RETURN v_spend_tracker_id;
END;
$$;