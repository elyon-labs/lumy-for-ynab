-- Helper function to recursively delete condition trees
CREATE OR REPLACE FUNCTION delete_condition_recursive(
  p_condition_id UUID,
  p_user_id UUID DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
  v_child_condition_id UUID;
BEGIN
  -- Recursively delete child conditions first
  FOR v_child_condition_id IN 
    SELECT id FROM spend_tracker_conditions 
    WHERE parent_id = p_condition_id
  LOOP
    PERFORM delete_condition_recursive(v_child_condition_id, p_user_id);
  END LOOP;
  
  -- Delete any test for this condition
  DELETE FROM spend_tracker_tests 
  WHERE condition_id = p_condition_id;
  
  -- Delete the condition itself
  DELETE FROM spend_tracker_conditions 
  WHERE id = p_condition_id;
END;
$$;