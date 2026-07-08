-- Create atomic spend tracker update function
CREATE OR REPLACE FUNCTION update_spend_tracker_atomic(
  p_spend_tracker_id UUID,
  p_user_id UUID,
  p_condition JSONB
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_old_root_condition_id UUID;
  v_new_root_condition_id UUID;
BEGIN
  -- Get the current root condition ID
  SELECT condition_id INTO v_old_root_condition_id
  FROM spend_trackers 
  WHERE id = p_spend_tracker_id;
  
  IF v_old_root_condition_id IS NULL THEN
    RAISE EXCEPTION 'Spend tracker with id % not found', p_spend_tracker_id;
  END IF;
  
  -- Create new condition tree
  v_new_root_condition_id := insert_condition_recursive(p_condition, NULL, p_user_id);
  
  -- Update the tracker to point to new root condition
  UPDATE spend_trackers 
  SET condition_id = v_new_root_condition_id
  WHERE id = p_spend_tracker_id;
  
  -- Delete the old condition tree
  PERFORM delete_condition_recursive(v_old_root_condition_id, p_user_id);
END;
$$;