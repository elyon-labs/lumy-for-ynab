-- Helper function to recursively insert conditions
CREATE OR REPLACE FUNCTION insert_condition_recursive(
  p_condition JSONB,
  p_parent_id UUID DEFAULT NULL,
  p_user_id UUID DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_condition_id UUID;
  v_condition_type TEXT;
  v_test JSONB;
  v_test_type TEXT;
  v_test_value TEXT;
  v_sub_condition JSONB;
  v_sub_conditions JSONB;
BEGIN
  -- Extract condition type
  v_condition_type := p_condition->>'type';
  
  -- Insert the condition
  INSERT INTO spend_tracker_conditions (type, parent_id, user_id)
  VALUES (v_condition_type, p_parent_id, p_user_id)
  RETURNING id INTO v_condition_id;
  
  -- Check if this is a test condition
  v_test := p_condition->'test';
  IF v_test IS NOT NULL THEN
    v_test_type := v_test->>'type';
    v_test_value := v_test->>'value';
    
    -- Insert the test
    INSERT INTO spend_tracker_tests (condition_id, type, value, user_id)
    VALUES (v_condition_id, v_test_type, v_test_value, p_user_id);
  END IF;
  
  -- Check if this condition has sub-conditions
  v_sub_conditions := p_condition->'conditions';
  IF v_sub_conditions IS NOT NULL AND jsonb_array_length(v_sub_conditions) > 0 THEN
    -- Recursively insert each sub-condition
    FOR v_sub_condition IN SELECT * FROM jsonb_array_elements(v_sub_conditions)
    LOOP
      PERFORM insert_condition_recursive(v_sub_condition, v_condition_id, p_user_id);
    END LOOP;
  END IF;
  
  RETURN v_condition_id;
END;
$$;