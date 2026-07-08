-- Create atomic category view update function
CREATE OR REPLACE FUNCTION update_category_view_atomic(
  p_user_id UUID,
  p_category_view_id UUID,
  p_name TEXT,
  p_category_ids UUID[],
  p_category_group_ids UUID[]
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
  v_category_id UUID;
  v_category_group_id UUID;
BEGIN
  -- Update the category view name
  UPDATE category_views 
  SET name = p_name, user_id = p_user_id
  WHERE id = p_category_view_id;
  
  -- Delete existing category associations
  DELETE FROM category_view_categories 
  WHERE category_view_id = p_category_view_id;
  
  -- Delete existing category group associations
  DELETE FROM category_view_category_groups 
  WHERE category_view_id = p_category_view_id;
  
  -- Insert new category associations
  FOREACH v_category_id IN ARRAY p_category_ids
  LOOP
    INSERT INTO category_view_categories (category_id, category_view_id)
    VALUES (v_category_id, p_category_view_id);
  END LOOP;
  
  -- Insert new category group associations
  FOREACH v_category_group_id IN ARRAY p_category_group_ids
  LOOP
    INSERT INTO category_view_category_groups (category_group_id, category_view_id)
    VALUES (v_category_group_id, p_category_view_id);
  END LOOP;
  
  RETURN p_category_view_id;
END;
$$;