import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface TransactionTest {
  type: string;
  value?: string;
}

interface TransactionCondition {
  type: string;
  test?: TransactionTest;
  conditions?: TransactionCondition[];
}

interface InsertSpendTrackerRequest {
  user_id: string;
  budget_id: string;
  condition: TransactionCondition;
  name: string;
  nick_name?: string;
  created_at?: string;
}

interface InsertSpendTrackerCondition {
  type: string;
  parentId?: string;
  userId: string;
}

interface InsertSpendTrackerTest {
  conditionId: string;
  type: string;
  value?: string;
  userId: string;
}

interface InsertSpendTracker {
  name: string;
  budgetId: string;
  userId: string;
  conditionId: string;
  nickname?: string;
  createdAt?: string;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      },
    );

    const requestBody = await req.json();
    console.log("Request body:", JSON.stringify(requestBody));

    const { user_id, budget_id, condition, name, nick_name, created_at }:
      InsertSpendTrackerRequest = requestBody;

    // Prepare parameters with explicit null values for optional params
    const rpcParams = {
      p_budget_id: budget_id,
      p_condition: condition,
      p_created_at: created_at || null,
      p_name: name,
      p_nickname: nick_name || null,
      p_user_id: user_id,
    };

    console.log("RPC parameters:", JSON.stringify(rpcParams));

    // Start a transaction using a stored procedure
    const { data: result, error } = await supabaseClient.rpc(
      "insert_spend_tracker_atomic",
      rpcParams,
    );

    if (error) {
      console.error("Error inserting spend tracker:", error);
      return new Response(
        JSON.stringify({ error: error.message }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 400,
        },
      );
    }

    return new Response(
      JSON.stringify({ id: result }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      },
    );
  } catch (error) {
    console.error("Unexpected error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      },
    );
  }
});
