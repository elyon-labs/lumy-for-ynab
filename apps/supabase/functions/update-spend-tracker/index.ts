import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
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

interface UpdateSpendTrackerRequest {
  spend_tracker_id: string;
  user_id: string;
  condition: TransactionCondition;
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

    const { spend_tracker_id, user_id, condition }: UpdateSpendTrackerRequest =
      requestBody;

    // Prepare parameters with explicit null values for optional params
    const rpcParams = {
      p_spend_tracker_id: spend_tracker_id,
      p_user_id: user_id,
      p_condition: condition,
    };

    console.log("RPC parameters:", JSON.stringify(rpcParams));

    // Start a transaction using a stored procedure
    const { error } = await supabaseClient.rpc(
      "update_spend_tracker_atomic",
      rpcParams,
    );

    if (error) {
      console.error("Error updating spend tracker:", error);
      return new Response(
        JSON.stringify({ error: error.message }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 400,
        },
      );
    }

    return new Response(
      JSON.stringify({ success: true }),
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
