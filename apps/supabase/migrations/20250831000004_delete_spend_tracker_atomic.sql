-- Create atomic spend tracker deletion function
CREATE OR REPLACE FUNCTION delete_spend_tracker_atomic(
  p_spend_tracker_id UUID,
  p_user_id UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_root_condition_id UUID;
BEGIN
  -- Get the root condition ID for the tracker
  SELECT condition_id INTO v_root_condition_id
  FROM spend_trackers 
  WHERE id = p_spend_tracker_id;
  
  IF v_root_condition_id IS NULL THEN
    RAISE EXCEPTION 'Spend tracker with id % not found', p_spend_tracker_id;
  END IF;
  
  -- Delete the tracker first (to maintain referential integrity)
  DELETE FROM spend_trackers 
  WHERE id = p_spend_tracker_id;
  
  -- Then delete the entire condition tree
  PERFORM delete_condition_recursive(v_root_condition_id, p_user_id);
END;
$$;