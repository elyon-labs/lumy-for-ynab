-- Create atomic category view insertion function
CREATE OR REPLACE FUNCTION insert_category_view_atomic(
  p_user_id UUID,
  p_name TEXT,
  p_budget_id UUID,
  p_category_ids UUID[],
  p_category_group_ids UUID[]
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_category_view_id UUID;
  v_category_id UUID;
  v_category_group_id UUID;
BEGIN
  -- Insert the category view
  INSERT INTO category_views (user_id, name, budget_id)
  VALUES (p_user_id, p_name, p_budget_id)
  RETURNING id INTO v_category_view_id;
  
  -- Insert category view categories
  FOREACH v_category_id IN ARRAY p_category_ids
  LOOP
    INSERT INTO category_view_categories (category_id, category_view_id)
    VALUES (v_category_id, v_category_view_id);
  END LOOP;
  
  -- Insert category view category groups
  FOREACH v_category_group_id IN ARRAY p_category_group_ids
  LOOP
    INSERT INTO category_view_category_groups (category_group_id, category_view_id)
    VALUES (v_category_group_id, v_category_view_id);
  END LOOP;
  
  RETURN v_category_view_id;
END;
$$;