import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface SubTransaction {
  category_id?: string;
  amount?: number;
  is_inflow?: boolean;
  payee_id?: string;
  memo?: string;
}

interface InsertTemplateRequest {
  user_id: string;
  budget_id: string;
  draft: {
    name: string;
    is_inflow: boolean;
    amount?: number;
    account_id?: string;
    category_id?: string;
    payee_id?: string;
    memo?: string;
    fire_immediately: boolean;
    flag?: string;
    sub_transactions: SubTransaction[];
  };
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

    const { user_id, budget_id, draft }: InsertTemplateRequest = requestBody;

    // Prepare parameters
    const rpcParams = {
      p_user_id: user_id,
      p_budget_id: budget_id,
      p_name: draft.name,
      p_is_inflow: draft.is_inflow,
      p_amount: draft.amount,
      p_account_id: draft.account_id,
      p_category_id: draft.category_id,
      p_payee_id: draft.payee_id,
      p_memo: draft.memo,
      p_fire_immediately: draft.fire_immediately,
      p_flag: draft.flag,
      p_sub_transactions: draft.sub_transactions,
    };

    console.log("RPC parameters:", JSON.stringify(rpcParams));

    // Start a transaction using a stored procedure
    const { data: result, error } = await supabaseClient.rpc(
      "insert_template_atomic",
      rpcParams,
    );

    if (error) {
      console.error("Error inserting template:", error);
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
