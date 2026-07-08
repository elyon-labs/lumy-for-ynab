import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface DeleteSpendTrackerRequest {
  spend_tracker_id: string;
  user_id: string;
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

    const { spend_tracker_id, user_id }: DeleteSpendTrackerRequest =
      requestBody;

    // Prepare parameters
    const rpcParams = {
      p_spend_tracker_id: spend_tracker_id,
      p_user_id: user_id,
    };

    console.log("RPC parameters:", JSON.stringify(rpcParams));

    // Start a transaction using a stored procedure
    const { error } = await supabaseClient.rpc(
      "delete_spend_tracker_atomic",
      rpcParams,
    );

    if (error) {
      console.error("Error deleting spend tracker:", error);
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
