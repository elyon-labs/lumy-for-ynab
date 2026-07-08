import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface InsertFrugalMonthRequest {
  user_id: string;
  budget_id: string;
  month: string;
  target_amount: number;
  category_ids: string[];
  account_ids: string[];
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

    const {
      user_id,
      budget_id,
      month,
      target_amount,
      category_ids,
      account_ids,
    }: InsertFrugalMonthRequest = requestBody;

    // Prepare parameters
    const rpcParams = {
      p_user_id: user_id,
      p_budget_id: budget_id,
      p_month: month,
      p_target_amount: target_amount,
      p_category_ids: category_ids,
      p_account_ids: account_ids,
    };

    console.log("RPC parameters:", JSON.stringify(rpcParams));

    // Start a transaction using a stored procedure
    const { data: result, error } = await supabaseClient.rpc(
      "insert_frugal_month_atomic",
      rpcParams,
    );

    if (error) {
      console.error("Error inserting frugal month:", error);
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
